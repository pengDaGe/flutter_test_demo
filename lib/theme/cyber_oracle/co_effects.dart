import 'package:flutter/material.dart';

import 'co_colors.dart';

/// Cyber-Oracle Editorial · 视觉效果 Token
///
/// 系统**禁止**传统的 BoxShadow（"Web 2.0" 触感）；
/// 深度通过：
/// 1. **Tonal Layering** —— 通过 `surface*` 颜色层级；
/// 2. **Atmospheric Diffusion** —— Ambient Glow（霓虹外发光）。
class CoEffects {
  CoEffects._();

  /// Glassmorphism 模糊半径。
  static const double glassBlurSigma = 20;

  /// Glassmorphism 背景：`surfaceVariant` @ 40% opacity。
  static Color glassBackground = CoColors.surfaceVariant.withValues(alpha: 0.40);

  /// Glassmorphism 顶部 Inner Glow，捕获顶部光线。
  static Color glassInnerGlow = CoColors.onSurface.withValues(alpha: 0.10);

  /// Card 上的渐变叠层：`primary -> primaryContainer` @ 15% opacity。
  static const Gradient cardSoulOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x26DE8EFF), // primary @ 15%
      Color(0x264B1E6F), // primaryContainer @ 15%
    ],
  );

  /// Oracle Portal 的旋转渐变描边。
  static const Gradient portalRingGradient = SweepGradient(
    startAngle: 0,
    endAngle: 6.28318530718, // 2π
    colors: [
      CoColors.primary,
      CoColors.secondary,
      CoColors.tertiary,
      CoColors.primary,
    ],
  );

  /// Ambient Glow（环境霓虹外发光）。
  ///
  /// 模拟霓虹灯洒在黑街上的散射，**而不是** 投影。
  /// - [color] 常用 [CoColors.primaryDim] / [CoColors.secondaryDim] / [CoColors.tertiaryDim]；
  /// - [opacity] 推荐 0.10；
  /// - [blur] 推荐 40。
  static List<BoxShadow> ambientGlow({
    Color color = CoColors.primaryDim,
    double opacity = 0.10,
    double blur = 40,
    double spread = 0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  /// FAB 的 Ambient Glow 预设。
  static List<BoxShadow> fabGlow = ambientGlow();

  /// Savage Mode Card 的外发光（Neon Red）。
  static List<BoxShadow> savageGlow = ambientGlow(color: CoColors.secondaryDim);

  /// Wealth Mode Card 的外发光（Cyber Gold）。
  static List<BoxShadow> wealthGlow = ambientGlow(color: CoColors.tertiaryDim);
}
