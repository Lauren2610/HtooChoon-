import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/plan_colors.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';

import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/logister_parent.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/plan_selection_screen.dart';
import 'package:htoochoon_flutter/Theme/theme_provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3A4F7A),
          secondary: Color(0xFFB6E2C6),
          background: Color(0xFFF1FFF8),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Color(0xFF3A4F7A),
          onBackground: Color(0xFF3A4F7A),
          onSurface: Color(0xFF3A4F7A),
        ),
        extensions: const [
          PlanColors(
            basic: Color(0xFFF1FFF8),
            pro: Color(0xFFB6E2C6),
            premium: Color(0xFF3A4F7A),
          ),
        ],
      ),
      home: const LoginScreen(),
    );
  }
}
