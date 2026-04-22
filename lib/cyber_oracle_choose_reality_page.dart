import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'theme/cyber_oracle/cyber_oracle.dart';
import 'widgets/cyber_oracle/cyber_oracle_widgets.dart';

/// Cyber-Oracle · "Choose Your Reality" 页面
///
/// 用户在登录后进入，选择一个「神谕模式」。每张卡片代表一种 vibe，
/// 严格遵循 [`design.md`](../../design.md) / `Cyber-Oracle Editorial`：
/// - Dark only
/// - 非对称、巨字号 Display 标题
/// - 无分割线，仅靠 surface 层级 + Ambient Glow 切分
/// - Glassmorphism「Oracle Insight」浮层
@RoutePage()
class CyberOracleChooseRealityPage extends StatefulWidget {
  const CyberOracleChooseRealityPage({super.key});

  @override
  State<CyberOracleChooseRealityPage> createState() =>
      _CyberOracleChooseRealityPageState();
}

class _CyberOracleChooseRealityPageState
    extends State<CyberOracleChooseRealityPage> {
  _OracleMode _selected = _OracleMode.savage;

  static const List<_OracleMode> _modes = [
    _OracleMode.savage,
    _OracleMode.clearHeaded,
    _OracleMode.wealth,
    _OracleMode.love,
    _OracleMode.worker,
    _OracleMode.gettingRich,
    _OracleMode.mbti,
    _OracleMode.social,
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CyberOracleTheme.dark(),
      child: Scaffold(
        backgroundColor: CoColors.surface,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _TopBar(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: CoSpacing.lg),
                    const _Headline(),
                    const SizedBox(height: CoSpacing.xl),
                    _ModeGrid(
                      modes: _modes,
                      selected: _selected,
                      onSelected: (m) => setState(() => _selected = m),
                    ),
                    const SizedBox(height: CoSpacing.xl),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CoSpacing.lg,
                      ),
                      child: _OracleInsightCard(),
                    ),
                    const SizedBox(height: CoSpacing.xl),
                  ],
                ),
              ),
              const _BottomNavBar(currentIndex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 顶部栏
// ============================================================================

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoSpacing.lg,
        CoSpacing.md,
        CoSpacing.lg,
        CoSpacing.md,
      ),
      child: Row(
        children: [
          // 返回 + Logo
          GestureDetector(
            onTap: () => context.router.maybePop(),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: CoColors.primary,
                ),
                const SizedBox(width: CoSpacing.xs),
                Text(
                  'CYBER ORACLE',
                  style: CoTypography.labelLg.copyWith(
                    color: CoColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 头像占位
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CoColors.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 标题区（巨字号 Display + 副标）
// ============================================================================

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CoSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHOOSE YOUR',
            style: CoTypography.displaySm.copyWith(
              fontSize: 38,
              height: 1.05,
              color: CoColors.onSurface,
            ),
          ),
          Text(
            'REALITY',
            style: CoTypography.displaySm.copyWith(
              fontSize: 38,
              height: 1.05,
              color: CoColors.primary,
            ),
          ),
          const SizedBox(height: CoSpacing.md),
          Text(
            "SELECT A GATEWAY TO CALIBRATE THE ORACLE'S RESONANCE",
            style: CoTypography.labelMd.copyWith(
              color: CoColors.onSurfaceVariant,
              letterSpacing: 1.0,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 模式网格 2x4
// ============================================================================

class _ModeGrid extends StatelessWidget {
  const _ModeGrid({
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final List<_OracleMode> modes;
  final _OracleMode selected;
  final ValueChanged<_OracleMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CoSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: modes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: CoSpacing.md,
          mainAxisSpacing: CoSpacing.md,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (_, i) {
          final mode = modes[i];
          return _ModeCard(
            mode: mode,
            selected: mode == selected,
            onTap: () => onSelected(mode),
          );
        },
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final _OracleMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spec = mode.spec;
    final List<BoxShadow>? glow = selected || spec.alwaysGlow
        ? CoEffects.ambientGlow(
            color: spec.accent,
            opacity: selected ? 0.28 : 0.16,
            blur: selected ? 36 : 28,
          )
        : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CoRadius.md),
          boxShadow: glow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CoRadius.md),
          child: Stack(
            children: [
              // 卡片基底（更亮的 surface 层级 = 「lift」）
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: CoColors.surfaceContainerHigh,
                  ),
                ),
              ),
              // 「digital soul」渐变（仅在选中或 alwaysGlow 时叠加，呼吸感）
              if (selected || spec.alwaysGlow)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          spec.accent.withValues(alpha: 0.18),
                          spec.accent.withValues(alpha: 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              // 内容
              Padding(
                padding: const EdgeInsets.all(CoSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(spec.icon, size: 28, color: spec.accent),
                    const Spacer(),
                    Text(
                      spec.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CoTypography.headlineSm.copyWith(
                        fontSize: 20,
                        height: 1.15,
                        color: spec.titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: CoSpacing.sm),
                    Text(
                      spec.subtitle,
                      style: CoTypography.labelSm.copyWith(
                        color: CoColors.onSurfaceMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// "Oracle Insight" 玻璃浮层卡片
// ============================================================================

class _OracleInsightCard extends StatelessWidget {
  const _OracleInsightCard();

  @override
  Widget build(BuildContext context) {
    return CoGlassCard(
      padding: const EdgeInsets.all(CoSpacing.lg),
      glow: CoEffects.ambientGlow(
        color: CoColors.primaryDim,
        opacity: 0.15,
        blur: 32,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORACLE INSIGHT',
                style: CoTypography.labelMd.copyWith(
                  color: CoColors.primary,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: CoSpacing.md),
              Text(
                '"The void responds to the frequency you project. Choose your mode with intention."',
                style: CoTypography.headlineSm.copyWith(
                  fontFamily: CoTypography.humanFamily,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                  color: CoColors.onSurface,
                ),
              ),
            ],
          ),
          // 右下角的微弱旋转光晕图标，呼应 design.md 的 "asymmetry"
          Positioned(
            right: -16,
            bottom: -16,
            child: Opacity(
              opacity: 0.18,
              child: Icon(
                Icons.auto_awesome,
                size: 96,
                color: CoColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 底部导航
// ============================================================================

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex});

  final int currentIndex;

  static const _items = [
    (icon: Icons.auto_awesome, label: 'HOME'),
    (icon: Icons.change_history, label: 'VOID'),
    (icon: Icons.history, label: 'HISTORY'),
    (icon: Icons.person_outline, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        CoSpacing.lg,
        CoSpacing.md,
        CoSpacing.lg,
        CoSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(color: CoColors.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final selected = i == currentIndex;
          final color = selected ? CoColors.primary : CoColors.onSurfaceMuted;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 22, color: color),
                const SizedBox(height: CoSpacing.xs),
                Text(
                  item.label,
                  style: CoTypography.labelSm.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// 模式数据
// ============================================================================

enum _OracleMode {
  savage,
  clearHeaded,
  wealth,
  love,
  worker,
  gettingRich,
  mbti,
  social,
}

class _ModeSpec {
  const _ModeSpec({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.titleColor,
    this.alwaysGlow = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color titleColor;

  /// 即使未选中也保留霓虹光晕（用于把视觉重心压在「主打」模式上）。
  final bool alwaysGlow;
}

extension on _OracleMode {
  _ModeSpec get spec {
    switch (this) {
      case _OracleMode.savage:
        return const _ModeSpec(
          title: 'Savage\nMode',
          subtitle: 'BRUTAL HONESTY ONLY',
          icon: Icons.bolt,
          accent: CoColors.secondary,
          titleColor: CoColors.onSurface,
          alwaysGlow: true,
        );
      case _OracleMode.clearHeaded:
        return const _ModeSpec(
          title: 'Clear-\nheaded Mode',
          subtitle: 'LOGICAL SYNTHESIS',
          icon: Icons.wb_sunny_outlined,
          accent: CoColors.onSurface,
          titleColor: CoColors.onSurface,
        );
      case _OracleMode.wealth:
        return const _ModeSpec(
          title: 'God of\nWealth',
          subtitle: 'PROSPERITY RITUALS',
          icon: Icons.monetization_on_outlined,
          accent: CoColors.tertiary,
          titleColor: CoColors.tertiary,
          alwaysGlow: true,
        );
      case _OracleMode.love:
        return const _ModeSpec(
          title: 'Love Mode',
          subtitle: 'AFFECTION ALGORITHMS',
          icon: Icons.favorite,
          accent: CoColors.secondary,
          titleColor: CoColors.secondary,
          alwaysGlow: true,
        );
      case _OracleMode.worker:
        return const _ModeSpec(
          title: 'Worker Mode',
          subtitle: 'EFFICIENCY PROTOCOL',
          icon: Icons.precision_manufacturing_outlined,
          accent: CoColors.onSurfaceMuted,
          titleColor: CoColors.onSurface,
        );
      case _OracleMode.gettingRich:
        return const _ModeSpec(
          title: 'Getting Rich',
          subtitle: 'FORTUNE OPTIMIZATION',
          icon: Icons.currency_bitcoin,
          accent: CoColors.primary,
          titleColor: CoColors.primary,
          alwaysGlow: true,
        );
      case _OracleMode.mbti:
        return const _ModeSpec(
          title: 'MBTI Mode',
          subtitle: 'PERSONALITY SYNC',
          icon: Icons.psychology_outlined,
          accent: CoColors.primary,
          titleColor: CoColors.onSurface,
          alwaysGlow: true,
        );
      case _OracleMode.social:
        return const _ModeSpec(
          title: 'Social\nAnimal',
          subtitle: 'NETWORK DYNAMICS',
          icon: Icons.groups_outlined,
          accent: CoColors.onSurface,
          titleColor: CoColors.onSurface,
        );
    }
  }
}
