/// Cyber-Oracle Editorial · 间距与圆角 Token
///
/// 「No-Line Rule」要求用 **大间隙** 与 **背景层级** 切分内容，
/// 因此间距通常比常规 Material 略大。
class CoSpacing {
  CoSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;
  static const double xxl = 64;
  static const double xxxl = 96;

  /// 常规列表行之间的最小垂直距离。
  static const double listGap = md;

  /// 段落 / Section 之间的「呼吸」间距。
  static const double sectionGap = xl;

  /// Glass 容器内边距。
  static const double glassPadding = lg;
}

/// 圆角 Token。**最小** `24px / 1.5rem`，禁止使用尖锐转角。
class CoRadius {
  CoRadius._();

  /// 最小允许圆角。`24` 等同 `1.5rem`（设计 don't 列表的下限）。
  static const double sm = 24;

  /// Card 默认。
  static const double md = 28;

  /// 大型容器（Modal / Hero Card）。
  static const double lg = 36;

  /// Pill / Chip。任意大数字均可。
  static const double pill = 999;
}
