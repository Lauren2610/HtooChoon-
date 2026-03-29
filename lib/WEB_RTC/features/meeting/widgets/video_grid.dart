import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../../../core/services/webrtc_service.dart';
import '../provider/meeting_provider.dart';

class VideoGrid extends StatelessWidget {
  final RTCVideoRenderer? localRenderer;
  final int participantCount;

  const VideoGrid({
    super.key,
    required this.localRenderer,
    required this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<MeetingProvider>(); // Just to trigger rebuild
    final webrtc = context.read<WebRTCService>();
    final remoteRenderers = webrtc.remoteRenderers;

    // 🌸 Debug: Print renderers
    print('🌸 [VideoGrid] Remote renderers count: ${remoteRenderers.length}');
    remoteRenderers.forEach((userId, renderer) {
      print(
        '🎨 [VideoGrid] Renderer for $userId: ${renderer != null ? "READY ✅" : "NULL ❌"}',
      );
    });

    // 🌸 Combine local + remote videos
    final List<_VideoItem> videos = [];

    if (localRenderer != null) {
      videos.add(
        _VideoItem(renderer: localRenderer!, label: "You", mirror: true),
      );
    }

    int index = 1;
    remoteRenderers.forEach((userId, renderer) {
      if (renderer != null) {
        videos.add(_VideoItem(renderer: renderer, label: "User $index"));
        index++;
      }
    });

    final count = videos.length;
    print('🎨 [VideoGrid] Total videos: $count');

    // 🌸 Dynamic layout
    if (count == 1) {
      return _singleLayout(videos.first);
    }

    if (count == 2) {
      return _twoLayout(videos);
    }

    if (count <= 4) {
      return _gridLayout(videos, scrollable: false);
    }

    return _gridLayout(videos, scrollable: true);
  }

  // =========================
  // Layouts
  // =========================

  Widget _singleLayout(_VideoItem video) {
    return Container(color: Colors.black, child: _videoTile(video));
  }

  Widget _twoLayout(List<_VideoItem> videos) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(child: _videoTile(videos[0])),
          Expanded(child: _videoTile(videos[1])),
        ],
      ),
    );
  }

  Widget _gridLayout(List<_VideoItem> videos, {required bool scrollable}) {
    final grid = GridView.builder(
      padding: const EdgeInsets.only(
        top: 100,
        bottom: 120,
        left: 12,
        right: 12,
      ),
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 16 / 9,
      ),
      itemBuilder: (context, index) {
        return _videoTile(videos[index]);
      },
    );

    return Container(color: Colors.black, child: grid);
  }

  // =========================
  // Video Tile
  // =========================

  Widget _videoTile(_VideoItem video) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade300, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            RTCVideoView(
              video.renderer,
              mirror: video.mirror,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),

            // 🌸 user label
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  video.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// Video Model
// =========================

class _VideoItem {
  final RTCVideoRenderer renderer;
  final String label;
  final bool mirror;

  _VideoItem({
    required this.renderer,
    required this.label,
    this.mirror = false,
  });
}
