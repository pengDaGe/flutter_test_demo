import 'package:flutter/material.dart';

/// Cyber-Oracle Editorial · 颜色 Token
///
/// 调色板根植于「虚空」(`#0D0D0D`)，以霓虹色作为「能量源」
/// 而非简单点缀。所有颜色遵循 Material 3 角色（surface / primary / etc.）
/// 但被重新调成赛博朋克审美。
///
/// 严禁：
/// - 使用 `#FFFFFF` 作为背景；
/// - 使用 1px 实线边框作为分区手段。
class CoColors {
  CoColors._();

  // --- The Void (Surfaces) ---------------------------------------------------
  /// 主画布。如「黑曜石镜面」。
  static const Color surface = Color(0xFF0E0E0E);

  /// 二级内容块（List 行、次级模块）。
  static const Color surfaceContainerLow = Color(0xFF161616);

  /// 三级容器（Card 默认背景）。
  static const Color surfaceContainer = Color(0xFF1C1C1F);

  /// 四级容器（嵌套 Card）。
  static const Color surfaceContainerHigh = Color(0xFF24242A);

  /// 顶层交互元素。
  static const Color surfaceContainerHighest = Color(0xFF2C2C34);

  /// 浅色 surface（用于 chip、弹窗等高亮容器）。
  static const Color surfaceBright = Color(0xFF35353F);

  /// 玻璃形态变体（与 alpha 配合使用，构成 Glassmorphism）。
  static const Color surfaceVariant = Color(0xFF2A2A33);

  // --- On Colors -------------------------------------------------------------
  /// 主体文本/图标颜色。注意：不是纯白。
  static const Color onSurface = Color(0xFFEDE9F2);

  /// 次级文本/图标。
  static const Color onSurfaceVariant = Color(0xFFB7B0C5);

  /// 极弱次级（disabled、metadata）。
  static const Color onSurfaceMuted = Color(0xFF6F6A82);

  // --- Primary · Neon Lavender (动作/能量) ---------------------------------
  static const Color primary = Color(0xFFDE8EFF);
  static const Color onPrimary = Color(0xFF1B0A29);
  static const Color primaryContainer = Color(0xFF4B1E6F);
  static const Color onPrimaryContainer = Color(0xFFF4DDFF);

  /// 用于「Ambient Glow」与边缘光晕。
  static const Color primaryDim = Color(0xFFB36BD9);

  /// 用于 Tertiary 文本按钮的固定色。
  static const Color primaryFixed = Color(0xFFE9B6FF);

  // --- Secondary · Neon Red (Savage Mode) -----------------------------------
  static const Color secondary = Color(0xFFFF3B6B);
  static const Color onSecondary = Color(0xFF2A0410);
  static const Color secondaryContainer = Color(0xFF6E0E2D);
  static const Color onSecondaryContainer = Color(0xFFFFD9E1);

  /// Savage Mode 的外发光。
  static const Color secondaryDim = Color(0xFFD93060);

  // --- Tertiary · Cyber Gold (Wealth Mode) ----------------------------------
  static const Color tertiary = Color(0xFFF2C14E);
  static const Color onTertiary = Color(0xFF2B1F00);
  static const Color tertiaryContainer = Color(0xFF6B5300);
  static const Color onTertiaryContainer = Color(0xFFFFE6A6);
  static const Color tertiaryDim = Color(0xFFC99A2E);

  // --- Status ----------------------------------------------------------------
  static const Color error = Color(0xFFFF5577);
  static const Color onError = Color(0xFF21000A);
  static const Color success = Color(0xFF6EF7C0);
  static const Color warning = Color(0xFFFFB257);
  static const Color info = Color(0xFF6FB4FF);

  // --- Outline (Ghost Border) -----------------------------------------------
  /// 轮廓基色（请始终配合低透明度使用，如 ≤15%）。
  static const Color outline = Color(0xFFEDE9F2);

  /// 「Ghost Border」回退色：`outlineVariant` @ 15% opacity。
  static Color get outlineVariant => onSurface.withValues(alpha: 0.15);

  /// 玻璃顶部 Inner Glow（捕获「光」的细节）。
  static Color get innerGlow => onSurface.withValues(alpha: 0.10);

  // --- Mode Accent Switching -------------------------------------------------
  /// 选择 Chip 切换全局强调色时使用。`Mode -> Color`。
  ///
  /// 例如：选中 Wealth -> [tertiary]；选中 Savage -> [secondary]；
  /// 选中 Love / Default -> [primary]。
  static Color accentForMode(CoAccentMode mode) {
    switch (mode) {
      case CoAccentMode.oracle:
        return primary;
      case CoAccentMode.savage:
        return secondary;
      case CoAccentMode.wealth:
        return tertiary;
    }
  }
}

/// 全局强调色模式。选中模式后应通过 `Theme` 的扩展或 GetX 状态全局切换。
enum CoAccentMode { oracle, savage, wealth }
