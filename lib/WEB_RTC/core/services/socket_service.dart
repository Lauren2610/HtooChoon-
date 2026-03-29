import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;
  String? _roomId; // Store roomId for signaling events

  final String _baseUrl;
  bool _isConnected = false; // ✅ Guard flag
  bool _isConnecting = false; // ✅ Prevent race condition

  SocketService({required String baseUrl}) : _baseUrl = baseUrl;

  void connect({
    required String token,
    required String roomId,
    required String participantId,
  }) {
    // ✅ PREVENT DUPLICATE CONNECTIONS!
    _roomId = roomId; // Store roomId for later use
    if (_isConnected && _socket?.connected == true) {
      print('⚠️ [Socket] Already connected, skipping connect()');
      return;
    }

    // ✅ PREVENT RACE CONDITION (multiple connect() calls before first completes)
    if (_isConnecting) {
      print('⚠️ [Socket] Already connecting, skipping connect()');
      return;
    }

    _isConnecting = true;

    _socket = IO.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'auth': {'token': token},
    });

    _socket?.onConnect((_) {
      print('✨[socket service] Connected to signaling server!');
      _isConnected = true;
      _isConnecting = false;
      _socket?.emit('join-room', {
        'roomId': roomId,
        'participantId': participantId,
      });
      print('🏠 Joined room: $roomId as $participantId');
    });

    _socket?.onDisconnect((_) {
      print('💔 Disconnected');
      _isConnected = false;
      _isConnecting = false;
    });

    _socket?.onError((e) {
      print('⚠️ Socket error: $e');
      _isConnecting = false;
    });
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void sendOffer(String targetId, Map<String, dynamic> offer) {
    emit('offer', {'to': targetId, 'sdp': offer, 'roomId': _roomId});
  }

  void sendAnswer(String targetId, Map<String, dynamic> answer) {
    emit('answer', {'to': targetId, 'sdp': answer, 'roomId': _roomId});
  }

  void sendIceCandidate(String targetId, Map<String, dynamic> candidate) {
    emit('ice-candidate', {'to': targetId, 'candidate': candidate, 'roomId': _roomId});
  }

  void raiseHand(bool isRaised) {
    emit('hand-raise', {'raised': isRaised});
  }

  void sendChatMessage(String message) {
    emit('chat-message', {
      'text': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void requestScreenShare(bool isSharing) {
    emit('screen-share', {'sharing': isSharing});
  }

  void leaveRoom() {
    emit('leave-room', {});
  }

  void dispose() {
    _socket?.dispose();
    _isConnected = false;
    _isConnecting = false;
  }

  bool get isConnected => _isConnected;
}
