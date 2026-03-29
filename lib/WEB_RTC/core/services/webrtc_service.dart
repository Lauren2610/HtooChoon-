import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'socket_service.dart';

typedef OnRenderersChanged = void Function();

class WebRTCService {
  MediaStream? _localStream;
  MediaStream? _localScreenStream;
  RTCVideoRenderer? localRenderer;

  Future<void> initLocalRenderer() async {
    localRenderer = RTCVideoRenderer();
    await localRenderer!.initialize();
    if (_localStream != null) {
      localRenderer!.srcObject = _localStream;
    }
  }

  Map<String, RTCPeerConnection> peerConnections = {};
  Map<String, RTCVideoRenderer> remoteRenderers = {};
  Future<void> createPeerConnectionFor(String remoteId, String roomId) async {
    final pc = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    // Add local tracks
    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    // Listen for remote tracks
    pc.onTrack = (event) async {
      final renderer = RTCVideoRenderer();
      await renderer.initialize();
      renderer.srcObject = event.streams[0];
      _remoteRenderers[remoteId] = renderer;

      // Notify UI callback
      onRenderersChanged?.call();
    };

    // Store the peer connection
    peerConnections[remoteId] = pc;

    // Create offer
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    // Send offer via socket
    _socket.emit("offer", {
      "roomId": roomId,
      "offer": offer.toMap(),
      "to": remoteId,
    });
  }

  final SocketService _socket;

  // ✅ Store multiple peer connections (one per remote user!)
  final Map<String, RTCPeerConnection> _peers = {};
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  OnRenderersChanged? onRenderersChanged;
  // ✅ Track processed signaling to prevent duplicates
  final Set<String> _processedOffers = {};
  final Set<String> _processedAnswers = {};

  // ✅ Queue ICE candidates that arrive before peer is ready
  final Map<String, List<Map<String, dynamic>>> _pendingIceCandidates = {};
  Map<String, RTCVideoRenderer> getRemoteRenderersCopy() {
    return Map.from(_remoteRenderers);
  }

  WebRTCService(this._socket);

  // 🎤📹 Initialize local media stream
  Future<void> initLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
        'width': {'ideal': 1280},
        'height': {'ideal': 720},
        'frameRate': {'ideal': 30},
      },
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints,
      );
      print('✨ [WEBRTC] Local stream ready!');
      print('🎤 Audio tracks: ${_localStream?.getAudioTracks().length ?? 0}');
      print('📹 Video tracks: ${_localStream?.getVideoTracks().length ?? 0}');
    } catch (e) {
      print('💔 [WEBRTC] getUserMedia failed: $e');
      rethrow;
    }
  }

  // 🔗 Create peer connection for a specific user
  Future<RTCPeerConnection> createPeerConnectionForUser(String userId) async {
    print('🎬 [WEBRTC] Creating peer connection for: $userId');

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        // 🔄 For production, add TURN server:
        // {'urls': 'turn:your-turn-server:3478', 'username': 'user', 'credential': 'pass'},
      ],
    };

    final peer = await createPeerConnection(config);
    _peers[userId] = peer;
    print('✅ [WEBRTC] Peer connection created for $userId');

    // 🎤📹 Add local tracks to peer
    _localStream?.getTracks().forEach((track) {
      print(
        '🎤📹 [WEBRTC] Adding local ${track.kind} track to peer for $userId',
      );
      print(
        '📹 [WEBRTC] Track details: enabled=${track.enabled}, muted=${track.muted}, id=${track.id}',
      );
      peer.addTrack(track, _localStream!);
    });

    // Log video track count explicitly
    final videoTracks = _localStream?.getVideoTracks();
    print(
      '📹 [WEBRTC] Local stream has ${videoTracks?.length ?? 0} video track(s)',
    );
    if (videoTracks?.isEmpty ?? true) {
      print(
        '⚠️ [WEBRTC] WARNING: No video tracks in local stream! Check getUserMedia constraints!',
      );
    }
    peer.onAddStream = (event) {
      print("Stream Track");
    };
    // 🧊 Handle ICE candidates
    peer.onIceCandidate = (candidate) {
      if (candidate != null) {
        print(
          '🧊 [WEBRTC] ICE candidate for $userId: ${candidate.candidate?.substring(0, 50)}...',
        );
        _socket.sendIceCandidate(userId, candidate.toMap());
      }
    };

    // 📹 Handle remote tracks (THE MAGIC!)
    peer.onTrack = (event) async {
      // ✅ Make it async!
      print('📹 [WEBRTC] 🎉🎉🎉 onTrack event from $userId! 🎉🎉🎉');
      print('📹 [WEBRTC] Stream count: ${event.streams.length}');
      print('📹 [WEBRTC] Track kind: ${event.track.kind}');
      print('📹 [WEBRTC] Track ID: ${event.track.id}');

      if (event.streams.isNotEmpty) {
        final renderer = RTCVideoRenderer();

        // ✅ AWAIT initialize() before setting srcObject!
        await renderer.initialize();
        print('📹 [WEBRTC] Renderer initialized for $userId');

        renderer.srcObject = event.streams[0];
        _remoteRenderers[userId] = renderer;
        onRenderersChanged?.call();
        print(
          '📹 [WEBRTC] ✅✅✅ Remote video renderer initialized for $userId! VIDEO READY! ✅✅✅',
        );

        // ✅ Notify UI to rebuild by updating state (if needed)
        // This depends on your architecture - you might need to call setState or update a provider
      } else {
        print('⚠️ [WEBRTC] onTrack received but NO STREAMS for $userId!');
      }
    };

    // 🔗 Monitor connection state
    peer.onConnectionState = (state) async {
      print('🔗 [WEBRTC] Connection state for $userId: $state');

      if (state == 'connected') {
        print('🎉 [WEBRTC] Peer connection ESTABLISHED with $userId! 💖');
      } else if (state == 'failed' ||
          state == 'closed' ||
          state == 'disconnected') {
        print('💔 [WEBRTC] Peer connection $state for $userId, cleaning up...');
        _cleanupPeer(userId);
      }
    };

    peer.onIceGatheringState = (state) {
      print('🧊 [WEBRTC] ICE gathering state for $userId: $state');
    };

    return peer;
  }

  // 📤 Create and send OFFER to a user
  Future<void> createAndSendOffer(String userId) async {
    print('🎬 [WEBRTC] 🚀 createAndSendOffer STARTED for $userId');

    final peer = await createPeerConnectionForUser(userId);
    print('🎬 [WEBRTC] Peer connection created');

    print('📝 [WEBRTC] Creating offer SDP...');
    final offer = await peer.createOffer();
    print(
      '📝 [WEBRTC] Offer SDP contains video: ${offer.sdp?.contains("m=video") ?? false}',
    );
    print('✅ [WEBRTC] Offer created: type=${offer.type}');

    print('📝 [WEBRTC] Setting local description...');
    await peer.setLocalDescription(offer);
    print('✅ [WEBRTC] Local description set');

    print('📩 [WEBRTC] Sending offer via socket to $userId');
    _socket.sendOffer(userId, offer.toMap());
    print('✅ [WEBRTC] 🚀 createAndSendOffer COMPLETED for $userId');
  }

  // 📥 Handle incoming OFFER (with duplicate guard & state checks)
  Future<void> handleOffer(
    String fromUserId,
    Map<String, dynamic> offer,
  ) async {
    // ✅ Generate unique ID to detect duplicates
    final offerId = '${fromUserId}_${offer['sdp']?.toString().hashCode}';

    if (_processedOffers.contains(offerId)) {
      print('⏭️ [WEBRTC] Duplicate offer detected, skipping: $offerId');
      return;
    }
    final sdp = offer['sdp'] as String?;
    print(
      '📝 [WEBRTC] Received offer contains video: ${sdp?.contains("m=video") ?? false}',
    );
    _processedOffers.add(offerId);

    // ✅ Check if peer already exists
    if (_peers.containsKey(fromUserId)) {
      final existingPeer = _peers[fromUserId]!;
      final existingState = await existingPeer.getSignalingState();
      if (existingState != 'stable') {
        print(
          '⏭️ [WEBRTC] Already processing offer from $fromUserId (state: $existingState), skipping',
        );
        return;
      }
      // If stable, clean up for renegotiation
      _peers.remove(fromUserId);
      existingPeer.close();
    }

    print('🎬 [WEBRTC] Handling offer from $fromUserId...');
    final peer = await createPeerConnectionForUser(fromUserId);

    print('📝 [WEBRTC] Setting remote description...');
    await peer.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );
    print('✅ [WEBRTC] Remote description set');

    print('📝 [WEBRTC] Creating answer...');
    final answer = await peer.createAnswer();
    print('✅ [WEBRTC] Answer created: ${answer.type}');

    await peer.setLocalDescription(answer);
    print('✅ [WEBRTC] Local description set for answer');

    print('📩 [WEBRTC] Sending answer to $fromUserId');
    _socket.sendAnswer(fromUserId, answer.toMap());
    print('✅ [WEBRTC] handleOffer COMPLETED for $fromUserId');
  }

  // 📥 Handle incoming ANSWER (with duplicate guard & state checks)
  Future<void> handleAnswer(
    String fromUserId,
    Map<String, dynamic> answer,
  ) async {
    // ✅ Duplicate guard (keep this!)
    final answerId = '${fromUserId}_${answer['sdp']?.toString().hashCode}';
    if (_processedAnswers.contains(answerId)) {
      print('⏭️ [WEBRTC] Duplicate answer detected, skipping: $answerId');
      return;
    }
    _processedAnswers.add(answerId);

    final peer = _peers[fromUserId];
    if (peer == null) {
      print('❌ [WEBRTC] No peer found for $fromUserId');
      return;
    }

    // ✅ FIX: Get signaling state and compare correctly!
    final signalingState = await peer.getSignalingState();
    print('🔍 [WEBRTC] Signaling state for $fromUserId: $signalingState');

    // ✅ Option 1: Check if state CONTAINS the expected value (more robust)
    if (!signalingState.toString().contains('HaveLocalOffer')) {
      if (signalingState.toString().contains('Stable')) {
        print('⏭️ [WEBRTC] Peer already stable, skipping for $fromUserId');
        return;
      }
      print(
        '⚠️ [WEBRTC] Unexpected state $signalingState for answer from $fromUserId',
      );
      // Don't return here - try to set anyway, WebRTC may handle it
    }

    try {
      print('📝 [WEBRTC] Setting remote answer for $fromUserId');
      await peer.setRemoteDescription(
        RTCSessionDescription(answer['sdp'], answer['type']),
      );
      print('✅ [WEBRTC] Remote answer set for $fromUserId');
    } catch (e) {
      print('❌ [WEBRTC] Failed to set remote answer: $e');
    }
  }

  // 🧊 Handle ICE candidate (with queuing for late arrivals)
  Future<void> handleIceCandidate(
    String fromUserId,
    Map<String, dynamic> candidate,
  ) async {
    final peer = _peers[fromUserId];

    if (peer == null) {
      // ✅ Queue candidate for later if peer doesn't exist yet
      print(
        '⏳ [WEBRTC] Queuing ICE candidate for $fromUserId (peer not ready)',
      );
      _pendingIceCandidates.putIfAbsent(fromUserId, () => []).add(candidate);
      return;
    }

    try {
      await peer.addCandidate(
        RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ),
      );
      print('🧊 [WEBRTC] Added ICE candidate from $fromUserId');
    } catch (e) {
      print('❌ [WEBRTC] Failed to add ICE candidate: $e');
    }

    // ✅ Process any pending candidates for this user
    if (_pendingIceCandidates.containsKey(fromUserId)) {
      final pendingList = _pendingIceCandidates[fromUserId]!;
      final count = pendingList.length; // ✅ Store count BEFORE removing!

      for (final pending in pendingList) {
        try {
          await peer.addCandidate(
            RTCIceCandidate(
              pending['candidate'],
              pending['sdpMid'],
              pending['sdpMLineIndex'],
            ),
          );
        } catch (_) {} // Ignore errors for late candidates
      }
      _pendingIceCandidates.remove(fromUserId);
      print(
        '✅ [WEBRTC] Processed $count pending ICE candidates for $fromUserId',
      );
    }
  }

  // 📱 Toggle screen sharing
  Future<void> toggleScreenShare(bool isSharing) async {
    if (isSharing) {
      try {
        _localScreenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': true,
          'audio': false,
        });
        print('📱 [WEBRTC] Screen sharing started!');

        final screenVideoTrack = _localScreenStream!.getVideoTracks().first;

        for (final entry in _peers.entries) {
          final userId = entry.key;
          final peer = entry.value;

          final senders = await peer.getSenders();
          try {
            final videoSender = senders.firstWhere(
              (s) => s.track?.kind == 'video',
            );
            await videoSender.replaceTrack(screenVideoTrack);
            print('🔄 [WEBRTC] Replaced with screen track for $userId');
          } catch (e) {
            print(
              '⚠️ [WEBRTC] Could not find video sender for $userId to replace: $e',
            );
          }
        }
      } catch (e) {
        print('💔 [WEBRTC] Screen share failed: $e');
      }
    } else {
      try {
        if (_localScreenStream != null) {
          _localScreenStream!.getTracks().forEach((track) => track.stop());
          _localScreenStream = null;
        }

        final cameraVideoTrack = _localStream?.getVideoTracks().first;
        if (cameraVideoTrack != null) {
          for (final entry in _peers.entries) {
            final userId = entry.key;
            final peer = entry.value;

            final senders = await peer.getSenders();
            try {
              final videoSender = senders.firstWhere(
                (s) => s.track?.kind == 'video',
              );
              await videoSender.replaceTrack(cameraVideoTrack);
              print('🔄 [WEBRTC] Reverted to camera track for $userId');
            } catch (e) {
              print(
                '⚠️ [WEBRTC] Could not find video sender for $userId to revert: $e',
              );
            }
          }
        }
      } catch (e) {
        print('💔 [WEBRTC] Reverting screen share failed: $e');
      }
    }
  }

  // 🧹 Clean up peer resources
  void _cleanupPeer(String userId) {
    print('🧹 [WEBRTC] Cleaning up peer for $userId');
    _peers[userId]?.close();
    _peers.remove(userId);
    _remoteRenderers[userId]?.dispose();
    _remoteRenderers.remove(userId);
    _pendingIceCandidates.remove(userId);

    // Optional: Clean up old processed signals to prevent memory leak
    if (_processedOffers.length > 100) _processedOffers.clear();
    if (_processedAnswers.length > 100) _processedAnswers.clear();
  }

  // 🎨 Getters for UI
  RTCVideoRenderer? getRemoteRenderer(String userId) =>
      _remoteRenderers[userId];

  MediaStream? get localStream => _localStream;
  String? get localStreamId => _localStream?.id;

  // 🗑️ Dispose all resources
  void dispose() {
    print('🗑️ [WEBRTC] Disposing all resources...');
    _localStream?.getTracks().forEach((track) => track.stop());
    _peers.forEach((userId, peer) {
      peer.close();
      print('🔗 [WEBRTC] Closed peer for $userId');
    });
    _peers.clear();
    _remoteRenderers.forEach((userId, renderer) {
      renderer.dispose();
      print('📹 [WEBRTC] Disposed renderer for $userId');
    });
    _remoteRenderers.clear();
    _pendingIceCandidates.clear();
    _processedOffers.clear();
    _processedAnswers.clear();
  }
}
