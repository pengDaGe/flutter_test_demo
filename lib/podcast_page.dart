import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  static const String _assetDir = 'assets/images/podcast';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          'Podcast',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'PingFang SC',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              '$_assetDir/icon_clock.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // History action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFF1C1C1E),
                    child: Image.asset(
                      '$_assetDir/image_main.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white24,
                              size: 64,
                            ),
                          ),
                    ),
                  ),
                  SvgPicture.asset(
                    '$_assetDir/icon_play.svg',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                  label: 'New',
                ),
                _buildActionButton(
                  child: SvgPicture.asset(
                    '$_assetDir/icon_redo.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Redo',
                ),
                _buildActionButton(
                  child: SvgPicture.asset(
                    '$_assetDir/icon_download.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Download',
                ),
                _buildActionButton(
                  child: SvgPicture.asset(
                    '$_assetDir/icon_share.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Share',
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              height: 5,
              width: 134,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required Widget child, required String label}) {
    return GestureDetector(
      onTap: () {
        // Handle action
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 24, height: 24, child: Center(child: child)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'PingFang SC',
            ),
          ),
        ],
      ),
    );
  }
}
