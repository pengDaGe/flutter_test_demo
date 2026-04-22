import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'co_colors.dart';
import 'co_spacing.dart';
import 'co_typography.dart';

/// Cyber-Oracle Editorial · Flutter ThemeData 工厂
///
/// 用法：
/// ```dart
/// MaterialApp(
///   theme: CyberOracleTheme.dark(),
///   home: ...,
/// );
/// ```
///
/// 整个系统**仅有 Dark 模式**——「The Neon Ritual」拒绝亮色界面。
class CyberOracleTheme {
  CyberOracleTheme._();

  /// 构造黑色赛博主题。
  static ThemeData dark({CoAccentMode accent = CoAccentMode.oracle}) {
    final Color accentColor = CoColors.accentForMode(accent);

    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: accentColor,
      onPrimary: CoColors.onPrimary,
      primaryContainer: CoColors.primaryContainer,
      onPrimaryContainer: CoColors.onPrimaryContainer,
      secondary: CoColors.secondary,
      onSecondary: CoColors.onSecondary,
      secondaryContainer: CoColors.secondaryContainer,
      onSecondaryContainer: CoColors.onSecondaryContainer,
      tertiary: CoColors.tertiary,
      onTertiary: CoColors.onTertiary,
      tertiaryContainer: CoColors.tertiaryContainer,
      onTertiaryContainer: CoColors.onTertiaryContainer,
      error: CoColors.error,
      onError: CoColors.onError,
      surface: CoColors.surface,
      onSurface: CoColors.onSurface,
      surfaceContainerLowest: CoColors.surface,
      surfaceContainerLow: CoColors.surfaceContainerLow,
      surfaceContainer: CoColors.surfaceContainer,
      surfaceContainerHigh: CoColors.surfaceContainerHigh,
      surfaceContainerHighest: CoColors.surfaceContainerHighest,
      surfaceBright: CoColors.surfaceBright,
      surfaceDim: CoColors.surface,
      surfaceTint: accentColor,
      onSurfaceVariant: CoColors.onSurfaceVariant,
      outline: CoColors.outline,
      outlineVariant: CoColors.outlineVariant,
      inverseSurface: CoColors.onSurface,
      onInverseSurface: CoColors.surface,
      inversePrimary: CoColors.primaryContainer,
      shadow: Colors.transparent,
      scrim: Colors.black54,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CoColors.surface,
      canvasColor: CoColors.surface,
      splashFactory: InkSparkle.splashFactory,
      textTheme: CoTypography.textTheme.apply(
        bodyColor: CoColors.onSurface,
        displayColor: CoColors.onSurface,
      ),

      // === No-Line Rule ====================================================
      // 全局禁用 Material 默认 Divider（厚重的灰线会破坏「Ritual」氛围）。
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
      ),

      // === AppBar (Glassmorphism friendly) =================================
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: CoTypography.titleLg,
        iconTheme: const IconThemeData(color: CoColors.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // === Card ============================================================
      cardTheme: CardThemeData(
        color: CoColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CoRadius.md),
        ),
      ),

      // === Buttons =========================================================
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: CoColors.onPrimary,
          textStyle: CoTypography.labelLg,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: CoSpacing.lg,
            vertical: CoSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoRadius.sm),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor.withValues(alpha: 0.20)),
          textStyle: CoTypography.labelLg,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: CoSpacing.lg,
            vertical: CoSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoRadius.sm),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CoColors.primaryFixed,
          textStyle: CoTypography.labelLg,
          padding: const EdgeInsets.symmetric(
            horizontal: CoSpacing.md,
            vertical: CoSpacing.sm,
          ),
        ),
      ),

      // === Floating Action Button =========================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: CoColors.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const StadiumBorder(),
      ),

      // === Chips (Mode Selectors) =========================================
      chipTheme: ChipThemeData(
        backgroundColor: CoColors.surfaceContainerLow,
        selectedColor: accentColor,
        labelStyle: CoTypography.labelMd.copyWith(color: CoColors.onSurface),
        secondaryLabelStyle: CoTypography.labelMd.copyWith(
          color: CoColors.onPrimary,
        ),
        side: BorderSide.none,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: CoSpacing.md,
          vertical: CoSpacing.sm,
        ),
        shape: const StadiumBorder(),
      ),

      // === Inputs (Hollow) ================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: CoSpacing.md,
        ),
        hintStyle: CoTypography.headlineSm.copyWith(
          color: CoColors.onSurfaceMuted,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: CoTypography.labelMd,
        floatingLabelStyle: CoTypography.labelMd.copyWith(color: accentColor),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: CoColors.outlineVariant),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CoColors.outlineVariant),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: CoColors.error),
        ),
      ),

      // === Bottom Sheet (Glass) ===========================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: CoColors.surfaceContainerHigh.withValues(alpha: 0.85),
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: CoColors.surfaceContainerHigh.withValues(
          alpha: 0.85,
        ),
        modalElevation: 0,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(CoRadius.lg),
          ),
        ),
      ),

      // === Dialog (Glass) =================================================
      dialogTheme: DialogThemeData(
        backgroundColor: CoColors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CoRadius.lg),
        ),
        titleTextStyle: CoTypography.headlineSm,
        contentTextStyle: CoTypography.bodyLg,
      ),

      // === Snackbar / Toast ===============================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CoColors.surfaceContainerHighest,
        contentTextStyle: CoTypography.bodyMd.copyWith(
          color: CoColors.onSurface,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CoRadius.sm),
        ),
      ),

      // === Tabs ===========================================================
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        labelColor: CoColors.onSurface,
        unselectedLabelColor: CoColors.onSurfaceMuted,
        labelStyle: CoTypography.labelLg,
        unselectedLabelStyle: CoTypography.labelLg,
        dividerColor: Colors.transparent,
      ),

      // === Switch / Slider ================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CoColors.onPrimary
              : CoColors.onSurfaceMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accentColor
              : CoColors.surfaceContainerHigh,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentColor,
        inactiveTrackColor: CoColors.surfaceContainerHigh,
        thumbColor: accentColor,
        overlayColor: accentColor.withValues(alpha: 0.2),
      ),

      // === Progress Indicators ============================================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: CoColors.surfaceContainerHigh,
        circularTrackColor: CoColors.surfaceContainerHigh,
      ),
    );
  }
}
