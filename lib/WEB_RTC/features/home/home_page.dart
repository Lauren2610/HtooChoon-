import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _uuid = const Uuid();

  void _joinRoom() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Room ID! 🥺')),
      );
      return;
    }

    // 🚀 Navigate to Lobby first (to check mic/cam)
    Navigator.pushNamed(
      context,
      '/lobby',
      arguments: {'roomId': _controller.text.trim()},
    );
  }

  void _createRoom() {
    final newRoomId = _uuid.v4().substring(0, 6).toUpperCase();
    _controller.text = newRoomId;
    // 🎉 Auto-join after a short delay!
    Future.delayed(const Duration(milliseconds: 500), _joinRoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌸 Cute Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.video_call,
                  size: 60,
                  color: Colors.pink[400],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Meet Kawaii',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 40),
              // 📝 Room ID Input
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Room ID...',
                  prefixIcon: const Icon(
                    Icons.meeting_room,
                    color: Colors.pink,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.pink[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 🚀 Join Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _joinRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Join Room ✨',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ➕ Create Room Button
              TextButton.icon(
                onPressed: _createRoom,
                icon: const Icon(Icons.add_circle_outline, color: Colors.pink),
                label: const Text(
                  'Create New Room',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
