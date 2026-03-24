import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Screens/LMS/live_session_detail_screen.dart';
import 'package:htoochoon_flutter/Screens/LMS/live_session_list_screen.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/lobby/lobby_page.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/meeting/page/meeting_page.dart';
import 'package:htoochoon_flutter/lms_demo/demo_services.dart';
import 'package:htoochoon_flutter/lms_demo/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StudentJoinSessionPage extends StatefulWidget {
  const StudentJoinSessionPage({super.key});

  @override
  State<StudentJoinSessionPage> createState() => _StudentJoinSessionPageState();
}

class _StudentJoinSessionPageState extends State<StudentJoinSessionPage> {
  final TextEditingController codeController = TextEditingController();
  final participantId = "student_${DateTime.now().millisecondsSinceEpoch}";
  Future<void> joinSession() async {
    final joinCode = codeController.text.trim();

    if (joinCode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a join code")));
      return;
    }

    try {
      // Await the async method
      final demoService = context.read<DemoServices>();
      final session = await demoService.findLiveSessionByCode(joinCode);

      if (session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session not found or not live")),
        );
        return;
      }

      // Request permissions
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !micStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Camera and Microphone permissions are required"),
          ),
        );
        return;
      }

      final roomId = session.id; // ✅ now valid because we awaited
      print("🚀 Navigating to LobbyPage with roomId: $roomId");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              LobbyPage(roomId: roomId, participantId: participantId),
        ),
      );
    } catch (e) {
      print('💥 joinSession error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to join session")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final demoService = context.watch<DemoServices>();

    // final liveSessions = demoService.sessions
    //     .where((s) => s.status == "live")
    //     .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Join Live Session")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter Session Code", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Example: crs1",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(onPressed: joinSession, child: const Text("Join")),

            const SizedBox(height: 30),

            const Divider(),

            const Text("Live Sessions", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: liveSessions.length,
            //     itemBuilder: (context, index) {
            //       final session = liveSessions[index];
            //
            //       return ListTile(
            //         title: Text("Course: ${session.courseId}"),
            //         subtitle: const Text("LIVE NOW"),
            //         trailing: ElevatedButton(
            //           child: const Text("Join"),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (_) => LobbyPage(
            //                   roomId: session.id,
            //                   // sessionId: session.id,
            //                   // courseId: session.courseId,
            //                   // role: "student",
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
