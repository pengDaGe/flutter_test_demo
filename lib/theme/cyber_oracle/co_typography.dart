import 'package:flutter/material.dart';

import 'co_colors.dart';

/// Cyber-Oracle Editorial · 字体声音
///
/// - **Display / Headline → Space Grotesk**：神谕之声，wide & brutalist。
/// - **Body / Title → Manrope**：人之声，几何且高度可读。
/// - **Label → Plus Jakarta Sans**：数据之声，技术性 metadata。
///
/// 字体需通过 `pubspec.yaml` 的 `fonts:` 段或 `google_fonts` 包接入。
/// 如使用 `google_fonts`，将 [oracleFamily]、[humanFamily]、[dataFamily]
/// 替换为 `GoogleFonts.spaceGrotesk()`...等的 `fontFamily` 即可。
class CoTypography {
  CoTypography._();

  /// 神谕之声（Headline / Display）。
  static const String oracleFamily = 'SpaceGrotesk';

  /// 人之声（Body / Title）。
  static const String humanFamily = 'Manrope';

  /// 数据之声（Label）。
  static const String dataFamily = 'PlusJakartaSans';

  // --- Display (用于「答案」、单字回答等极致冲击) -----------------------
  static const TextStyle displayLg = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -2.88, // -0.04em
    color: CoColors.onSurface,
  );

  static const TextStyle displayMd = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: -1.68, // -0.03em
    color: CoColors.onSurface,
  );

  static const TextStyle displaySm = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.88, // -0.02em
    color: CoColors.onSurface,
  );

  // --- Headline (用于卡片标题、重点回答) -------------------------------
  static const TextStyle headlineLg = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.34,
    color: CoColors.onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: CoColors.onSurface,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: oracleFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: CoColors.onSurface,
  );

  // --- Title (Manrope) -------------------------------------------------
  static const TextStyle titleLg = TextStyle(
    fontFamily: humanFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: CoColors.onSurface,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: humanFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: CoColors.onSurface,
  );

  static const TextStyle titleSm = TextStyle(
    fontFamily: humanFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: CoColors.onSurface,
  );

  // --- Body (Manrope) --------------------------------------------------
  static const TextStyle bodyLg = TextStyle(
    fontFamily: humanFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: CoColors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: humanFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: CoColors.onSurfaceVariant,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: humanFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: CoColors.onSurfaceVariant,
  );

  // --- Label (Plus Jakarta Sans) --------------------------------------
  static const TextStyle labelLg = TextStyle(
    fontFamily: dataFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.28, // 0.02em
    color: CoColors.onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: dataFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.48, // 0.04em
    color: CoColors.onSurfaceVariant,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: dataFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.8, // 0.08em
    color: CoColors.onSurfaceMuted,
  );

  /// 对应 Material 3 `TextTheme` 的整体映射。
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLg,
    displayMedium: displayMd,
    displaySmall: displaySm,
    headlineLarge: headlineLg,
    headlineMedium: headlineMd,
    headlineSmall: headlineSm,
    titleLarge: titleLg,
    titleMedium: titleMd,
    titleSmall: titleSm,
    bodyLarge: bodyLg,
    bodyMedium: bodyMd,
    bodySmall: bodySm,
    labelLarge: labelLg,
    labelMedium: labelMd,
    labelSmall: labelSm,
  );
}
