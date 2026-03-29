import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  final bool isMuted;
  final bool isVideoOff;
  final bool isHandRaised;
  final bool isScreenSharing;
  final VoidCallback onMute;
  final VoidCallback onVideo;
  final VoidCallback onHandRaise;
  final VoidCallback onScreenShare;
  final VoidCallback onLeave;

  const ControlBar({
    super.key,
    required this.isMuted,
    required this.isVideoOff,
    required this.isHandRaised,
    required this.isScreenSharing,
    required this.onMute,
    required this.onVideo,
    required this.onHandRaise,
    required this.onScreenShare,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            color: isMuted ? Colors.red : Colors.green,
            onTap: onMute,
            label: 'Mic',
          ),
          _buildControlButton(
            icon: isVideoOff ? Icons.videocam_off : Icons.videocam,
            color: isVideoOff ? Colors.red : Colors.green,
            onTap: onVideo,
            label: 'Cam',
          ),
          _buildControlButton(
            icon: Icons.pan_tool,
            color: isHandRaised ? Colors.orange : Colors.grey,
            onTap: onHandRaise,
            label: 'Raise',
            isToggled: isHandRaised,
          ),
          _buildControlButton(
            icon: Icons.screen_share,
            color: isScreenSharing ? Colors.purple : Colors.grey,
            onTap: onScreenShare,
            label: 'Share',
            isToggled: isScreenSharing,
          ),
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.red,
            onTap: onLeave,
            label: 'End',
            isDanger: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
    bool isToggled = false,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDanger
                  ? color.withOpacity(0.2)
                  : (isToggled ? color.withOpacity(0.2) : Colors.grey[800]),
              shape: BoxShape.circle,
              border: isToggled
                  ? Border.all(color: color, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}