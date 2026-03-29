import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/api/api_service.dart';
import 'package:provider/provider.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/services/webrtc_service.dart';
import '../provider/meeting_provider.dart';
import '../widgets/video_grid.dart';
import '../widgets/control_bar.dart';
import '../widgets/chat_panel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MeetingPage extends StatefulWidget {
  final String roomId;
  final RTCVideoRenderer? localRenderer;
  final String participantId;
  const MeetingPage({
    super.key,
    required this.roomId,
    required this.localRenderer,
    required this.participantId,
  });

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late WebRTCService webrtc;
  late SocketService socket;
  @override
  void initState() {
    super.initState();

    webrtc = context.read<WebRTCService>();

    webrtc.onRenderersChanged = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingProvider>(
      builder: (context, meeting, child) {
        final myId = meeting.myId;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, color: Colors.pink[300], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Room: ${widget.roomId}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                if (meeting.isHandRaised)
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.pan_tool,
                      color: Colors.orange[400],
                      size: 24,
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    meeting.isChatOpen
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                  onPressed: meeting.toggleChat,
                ),
                SizedBox(width: 8),
              ],
            ),
            body: Stack(
              children: [
                // Video Grid
                VideoGrid(
                  localRenderer: widget.localRenderer,
                  participantCount: meeting.participantIds.length + 1,
                ),

                // Chat Panel (popup overlay)
                if (meeting.isChatOpen)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ChatPanel(
                          messages: meeting.messages,
                          onSend: meeting.addMessage,
                          onClose: meeting.toggleChat,
                        ),
                      ),
                    ),
                  ),

                // Control Bar (bottom)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ControlBar(
                    isMuted: meeting.isMuted,
                    isVideoOff: meeting.isVideoOff,
                    isHandRaised: meeting.isHandRaised,
                    isScreenSharing: meeting.isScreenSharing,
                    onMute: meeting.toggleMute,
                    onVideo: meeting.toggleVideo,
                    onHandRaise: meeting.toggleHandRaise,
                    onScreenShare: meeting.toggleScreenShare,
                    onLeave: () {
                      meeting.leaveMeeting();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
