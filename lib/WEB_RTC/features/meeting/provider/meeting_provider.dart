import 'package:flutter/foundation.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/services/webrtc_service.dart';
import '../models/chat_message.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MeetingProvider extends ChangeNotifier {
  final SocketService _socket;
  final WebRTCService _webrtc;
  final ApiService _apiService;
  final AuthProvider authProvider;

  bool _initialized = false;
  bool isMuted = false;
  bool isVideoOff = false;
  bool isHandRaised = false;
  bool isScreenSharing = false;
  bool isChatOpen = false;

  List<ChatMessage> messages = [];
  List<String> participantIds = [];

  MeetingProvider(
    this._socket,
    this._webrtc,
    this._apiService,
    this.authProvider,
  );

  String? get myId => authProvider.userId.toString();
  String? get token => authProvider.accessToken.toString();

  /// ✅ Initialize meeting: connect socket & set up listeners
  void init(String roomId) async {
    if (_initialized) return;
    _initialized = true;

    print('🎬 [MeetingProvider] Init called, myId=$myId');

    // 1️⃣ Connect socket
    _socket.connect(
      token: token.toString(),
      roomId: roomId,
      participantId: myId.toString(),
    );
    print('✅ [MeetingProvider] Socket connect called');

    // 2️⃣ Initialize local video/audio
    await _webrtc.initLocalStream();
    _webrtc.onRenderersChanged = () => notifyListeners();

    // 3️⃣ Listen for socket events
    _setupSocketListeners();

    print('✅ [MeetingProvider] Listeners setup complete');
  }

  /// Socket listeners
  void _setupSocketListeners() {
    print('🔔 [SOCKET] Setting up listeners for: $myId');

    // 🌟 Existing participants when joining a room
    _socket.on('participants', (data) async {
      final existingIds = List<String>.from(data['participants'] ?? []);
      final roomId = data['roomId'] as String;
      for (final participantId in existingIds) {
        if (participantId != myId && !participantIds.contains(participantId)) {
          participantIds.add(participantId);
          // ✅ Use createAndSendOffer to create peer and send offer
          await _webrtc.createAndSendOffer(participantId);
        }
      }
      print("AIGHT I FIRED PARTICIPANTSS");
      notifyListeners();
    });

    // 🌟 New participant joins
    _socket.on('user-joined', (data) async {
      final newUserId = data['participantId'] as String;
      if (!participantIds.contains(newUserId)) {
        participantIds.add(newUserId);
        notifyListeners();
        print(
          '🎬 [WEBRTC] Creating peer connection & sending offer for $newUserId',
        );
        await _webrtc.createAndSendOffer(newUserId);
      }
    });

    // 🌟 Receive offer
    _socket.on('offer', (data) async {
      final fromUserId = data['from'] as String;
      final targetId = data['targetId'] as String?;
      if (targetId != null && targetId != myId) return;
      final offer = data['sdp'] as Map<String, dynamic>;
      await _webrtc.handleOffer(fromUserId, offer);
    });

    // 🌟 Receive answer
    _socket.on('answer', (data) async {
      final fromUserId = data['from'] as String;
      final targetId = data['targetId'] as String?;
      if (targetId != null && targetId != myId) return;
      final answer = data['sdp'] as Map<String, dynamic>;
      await _webrtc.handleAnswer(fromUserId, answer);
    });

    // 🌟 Receive ICE candidate
    _socket.on('ice-candidate', (data) async {
      final fromUserId = data['from'] as String;
      final targetId = data['targetId'] as String?;
      if (targetId != null && targetId != myId) return;
      final candidate = data['candidate'] as Map<String, dynamic>;
      await _webrtc.handleIceCandidate(fromUserId, candidate);
    });

    // 🌟 Hand raise
    _socket.on('hand-raise', (data) {
      print('🙋 Hand raise from: ${data['participantId']}');
    });

    // 🌟 Chat messages
    _socket.on('chat-message', onRemoteMessage);

    print('✅ [SOCKET] All listeners registered for $myId');
  }

  void onRemoteMessage(dynamic data) {
    final msg = ChatMessage.fromMap(data, false);
    messages = List.from(messages)..add(msg);
    notifyListeners();
  }

  /// Toggle controls
  void toggleMute() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleVideo() {
    isVideoOff = !isVideoOff;
    notifyListeners();
  }

  void toggleHandRaise() {
    isHandRaised = !isHandRaised;
    notifyListeners();
    _socket.raiseHand(isHandRaised);
  }

  void toggleScreenShare() async {
    isScreenSharing = !isScreenSharing;
    notifyListeners();
    await _webrtc.toggleScreenShare(isScreenSharing);
    _socket.requestScreenShare(isScreenSharing);
  }

  void toggleChat() {
    isChatOpen = !isChatOpen;
    notifyListeners();
  }

  void addMessage(String text) {
    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderId: myId.toString(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );
    messages = List.from(messages)..add(msg);
    notifyListeners();
    _socket.sendChatMessage(text);
  }

  /// Leave meeting
  void leaveMeeting() {
    _socket.leaveRoom();
    _webrtc.dispose();
    _initialized = false;
    participantIds.clear();
    messages.clear();
  }
}
