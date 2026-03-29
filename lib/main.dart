import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/assignment_provider.dart';
import 'package:htoochoon_flutter/Providers/class_provider.dart';
import 'package:htoochoon_flutter/Providers/invitation_provider.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';

import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:htoochoon_flutter/Providers/structure_provider.dart';
import 'package:htoochoon_flutter/Providers/subscription_provider.dart';
import 'package:htoochoon_flutter/Providers/theme_provider.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/otp_screen.dart';
import 'package:htoochoon_flutter/Screens/Home/home_tab.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:htoochoon_flutter/Screens/Onboarding/onboarding_screen.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Screens/Teacher/Home/teacher_dashboard_screen.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/meeting/provider/meeting_provider.dart';
import 'package:htoochoon_flutter/api/api_service.dart';
import 'package:htoochoon_flutter/firebase_options.dart';
import 'package:htoochoon_flutter/lms_demo/demo_services.dart'; // DEMO MODE
import 'package:htoochoon_flutter/lms/forms/screens/lms_home_screen.dart';
import 'package:htoochoon_flutter/WEB_RTC/core/services/socket_service.dart';
import 'package:htoochoon_flutter/WEB_RTC/core/services/webrtc_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // New

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://htoochoon.kargate.site/",
      headers: {"Content-Type": "application/json"},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }

        handler.next(options);
      },
    ),
  );
  final apiService = ApiService(dio);

  runApp(
    MultiProvider(
      providers: [
        /// SERVICES
        Provider<ApiService>.value(value: apiService),

        // ✅ Single SocketService provider - update IP to match your network
        Provider<SocketService>(
          create: (_) =>
              SocketService(baseUrl: 'http://htoochoon.kargate.site:9690/'),
        ),

        ProxyProvider<SocketService, WebRTCService>(
          update: (_, socket, __) => WebRTCService(socket),
        ),

        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (context) => OrgProvider()),
        ChangeNotifierProvider(create: (context) => AssignmentProvider()),
        ChangeNotifierProvider(create: (context) => StructureProvider()),
        ChangeNotifierProvider(create: (context) => ClassProvider()),
        ChangeNotifierProvider(
          create: (context) => SubscriptionProvider(),
        ), // New
        /// MEETING PROVIDER (uses the SocketService and WebRTCService from providers above)
        ChangeNotifierProxyProvider4<
          SocketService,
          WebRTCService,
          ApiService,
          AuthProvider,
          MeetingProvider
        >(
          create: (context) => MeetingProvider(
            context.read<SocketService>(),
            context.read<WebRTCService>(),
            apiService,
            AuthProvider(apiService),
          ),
          update: (context, socket, webrtc, api, auth, previous) =>
              MeetingProvider(socket, webrtc, api, auth),
        ),

        ChangeNotifierProvider(create: (context) => InvitationProvider()),
        ChangeNotifierProvider(
          create: (context) => DemoServices(dio),
        ), // DEMO MODE
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HtooChoon',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.accessToken != null) {
      return MainScaffold();
    }

    return const PremiumLoginScreen();
  }
}
