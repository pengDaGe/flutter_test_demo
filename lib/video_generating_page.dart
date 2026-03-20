import 'dart:ui';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'utils/router_helper.dart';

@RoutePage()
class VideoGeneratingPage extends StatefulWidget {
  const VideoGeneratingPage({super.key});

  @override
  State<VideoGeneratingPage> createState() => _VideoGeneratingPageState();
}

class _VideoGeneratingPageState extends State<VideoGeneratingPage> {
  @override
  void initState() {
    super.initState();
    // Simulate generation completion
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        RouterHelper.replace(const VideoResultRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dashed border square with icon
            CustomPaint(
              painter: DashedRectPainter(
                color: Colors.white.withAlpha(128),
                strokeWidth: 1.5,
                gap: 5,
              ),
              child: Container(
                width: 140,
                height: 140,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined, // More suitable for video
                      color: Colors.white,
                      size: 48,
                    ),
                    Positioned(
                      top: 40,
                      right: 40,
                      child: Icon(
                        Icons.auto_awesome, // Sparkle
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Video generating...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Once generated, it can be viewed in the Gallery.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(150),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    this.color = Colors.white,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final double dashWidth = gap;
    final double dashSpace = gap;

    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
