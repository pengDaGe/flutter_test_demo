import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// Glassmorphism Card / Modal / Nav Bar 容器。
///
/// 公式：`surfaceVariant @ 40% opacity` + `BackdropFilter(20px)`
/// + 顶部 1px Inner Glow（捕获顶部光线）。
class CoGlassCard extends StatelessWidget {
  const CoGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(CoSpacing.lg),
    this.borderRadius,
    this.glow,
    this.gradientOverlay = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  /// 自定义霓虹外发光（如 [CoEffects.savageGlow] / [CoEffects.wealthGlow]）。
  /// 不传则不发光，仅依靠层级提示深度（推荐做法）。
  final List<BoxShadow>? glow;

  /// 是否叠加 `primary -> primaryContainer @ 15%` 的「digital soul」渐变。
  final bool gradientOverlay;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry radius =
        borderRadius ?? BorderRadius.circular(CoRadius.md);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: glow),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: CoEffects.glassBlurSigma,
            sigmaY: CoEffects.glassBlurSigma,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: CoEffects.glassBackground),
                ),
              ),
              if (gradientOverlay)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: CoEffects.cardSoulOverlay,
                    ),
                  ),
                ),
              // 顶部 Inner Glow（高光线条）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 1, color: CoEffects.glassInnerGlow),
              ),
              Padding(padding: padding, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
