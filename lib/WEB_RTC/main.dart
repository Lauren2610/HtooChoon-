import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/lobby/lobby_page.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/meeting/page/meeting_page.dart';
import 'package:htoochoon_flutter/WEB_RTC/core/services/socket_service.dart';
import 'package:htoochoon_flutter/WEB_RTC/core/services/webrtc_service.dart';
import 'features/home/home_page.dart';
import 'core/theme/app_theme.dart';

//
//
// void main() async {
//   // 🛡️ Ensure bindings are initialized
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 🎤 Request permissions early (optional, but good for UX!)
//   await _requestPermissions();
//
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<SocketService>(
//           create: (_) => SocketService(baseUrl: 'http://192.168.1.112:3000'),
//         ),
//         ProxyProvider<SocketService, WebRTCService>(
//           update: (_, socket, __) => WebRTCService(socket),
//         ),
//       ],
//       child: const MeetKawaiiApp(),
//     ),
//   );
// }
//
// Future<void> checkPermission() async {
//   final cameraStatus = await Permission.camera.status;
//   final micStatus = await Permission.microphone.status;
//
//   print("Camera permission given: ${cameraStatus.isGranted}");
//   print("Microphone permission given: ${micStatus.isGranted}");
//
//   if (!cameraStatus.isGranted) {
//     await Permission.camera.request();
//   }
//
//   if (!micStatus.isGranted) {
//     await Permission.microphone.request();
//   }
// }
//
// Future<void> _requestPermissions() async {
//   // 🎤 Mic & 📹 Camera
//   await [Permission.microphone, Permission.camera].request();
// }
//
// class MeetKawaiiApp extends StatelessWidget {
//   const MeetKawaiiApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Meet Kawaii 💖',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       home: const HomePage(), // 🏠 Start here!
//       // 🗺️ Named routes for easy navigation!
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case '/lobby':
//             final args = settings.arguments as Map<String, dynamic>;
//             return MaterialPageRoute(
//               builder: (_) => LobbyPage(roomId: args['roomId'] as String),
//             );
//           default:
//             return MaterialPageRoute(builder: (_) => const HomePage());
//         }
//       },
//     );
//   }
// }
