import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/WEB_RTC/core/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:htoochoon_flutter/WEB_RTC/features/meeting/page/meeting_page.dart';
import '../../core/services/webrtc_service.dart';

class LobbyPage extends StatefulWidget {
  final String roomId;
  final String participantId;
  const LobbyPage({
    super.key,
    required this.roomId,
    required this.participantId,
  });

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  MediaStream? _localStream;
  // ✅ Create renderer ONCE as a state variable
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  bool _isMicOn = true;
  bool _isCamOn = true;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _initRenderer();
    await _initPreview();

    _connectSocket();
    _setupSocketListeners();
  }

  void _connectSocket() {
    final socket = context.read<SocketService>();

    socket.connect(
      //TODO replace with real token later
      token: 'test',
      roomId: widget.roomId,
      participantId: widget.participantId,
    );
  }

  void _setupSocketListeners() {
    final socket = context.read<SocketService>();
    final webrtc = context.read<WebRTCService>();

    socket.on('existing-users', (users) {
      print('👥 Existing users: $users');

      for (var userId in users) {
        webrtc.createAndSendOffer(userId);
      }
    });

    socket.on('user-joined', (data) {
      final userId = data['userId'];
      print('🆕 User joined: $userId');

      webrtc.createAndSendOffer(userId);
    });

    socket.on('offer', (data) {
      webrtc.handleOffer(data['fromUserId'], data['sdp']);
    });

    socket.on('answer', (data) {
      webrtc.handleAnswer(data['fromUserId'], data['sdp']);
    });

    socket.on('ice-candidate', (data) {
      webrtc.handleIceCandidate(data['fromUserId'], data['candidate']);
    });
  }

  Future<void> _initRenderer() async {
    await _renderer.initialize();
  }

  Future<void> _initPreview() async {
    try {
      final webrtc = context.read<WebRTCService>();

      await webrtc.initLocalStream();

      final stream = webrtc.localStream;

      if (stream == null) {
        throw Exception("Local stream is null");
      }

      _renderer.srcObject = stream;

      if (!mounted) return;

      setState(() {
        _localStream = stream;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }
  // Future<void> _initPreview() async {
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final hasPermission = await PermissionService.requestMediaPermissions();
  //     if (!hasPermission) {
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = "Permissions denied! 🥺";
  //       });
  //       return;
  //     }
  //
  //     // ✅ Call WebRTCService.initLocalStream() instead of getUserMedia directly!
  //     // This ensures the SAME stream is used for both preview AND peer connections!
  //     await ref.read(webrtcServiceProvider).initLocalStream();
  //
  //     // ✅ Get the stream from WebRTCService
  //     final stream = ref.read(webrtcServiceProvider).localStream;
  //
  //     if (stream == null) {
  //       throw Exception('Failed to get local stream from WebRTCService');
  //     }
  //
  //     // ✅ Initialize renderer with the shared stream
  //     await _renderer.initialize();
  //     _renderer.srcObject = stream;
  //
  //     setState(() {
  //       _localStream = stream;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorMessage = "Error: $e";
  //     });
  //   }
  // }

  void _toggleMic() {
    if (_localStream == null) return;

    setState(() => _isMicOn = !_isMicOn);

    for (var track in _localStream!.getAudioTracks()) {
      track.enabled = _isMicOn;
    }
  }

  void _toggleCam() {
    if (_localStream == null) return;

    setState(() => _isCamOn = !_isCamOn);

    for (var track in _localStream!.getVideoTracks()) {
      track.enabled = _isCamOn;
    }
  }

  void _joinMeeting() {
    if (_localStream == null) {
      print('💔 Stream is null! Cannot join.');
      return;
    }

    print('🚀 Navigating to MeetingPage...'); // ✅ Debug print!

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeetingPage(
          roomId: widget.roomId,
          localRenderer: _renderer,
          participantId: widget.participantId,
          // participantId: _myId// ✅ Pass directly!
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   // 🧹 Clean up renderer!
  //   _renderer.dispose();
  //   _localStream?.dispose();
  //   super.dispose();
  // }
  @override
  void dispose() {
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.pink)
                  : _errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : RTCVideoView(
                      _renderer, // ✅ Use the initialized renderer!
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
            ),
          ),
          if (!_isLoading && _errorMessage == null)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLobbyButton(Icons.mic, _isMicOn, _toggleMic),
                  _buildLobbyButton(Icons.videocam, _isCamOn, _toggleCam),
                  ElevatedButton.icon(
                    onPressed: _joinMeeting,
                    icon: const Icon(Icons.call),
                    label: const Text('Join Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLobbyButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[800] : Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
