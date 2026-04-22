import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// **The Oracle Portal**
///
/// 大型圆形玻璃容器：用于主交互入口。
/// - 旋转的 `primary -> secondary` 渐变描边；
/// - 厚重的 BackdropFilter 模糊；
/// - 处于「思考 / 咨询虚空」状态时启动旋转动画（[thinking]=true）。
class CoOraclePortal extends StatefulWidget {
  const CoOraclePortal({
    super.key,
    this.size = 240,
    this.thinking = false,
    this.onTap,
    this.child,
  });

  final double size;

  /// 是否启动旋转描边（用于「Loading / Thinking」状态）。
  final bool thinking;

  final VoidCallback? onTap;
  final Widget? child;

  @override
  State<CoOraclePortal> createState() => _CoOraclePortalState();
}

class _CoOraclePortalState extends State<CoOraclePortal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    if (widget.thinking) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant CoOraclePortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.thinking && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.thinking && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double s = widget.size;
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: s,
        height: s,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Glow (always-on neon halo)
            Container(
              width: s,
              height: s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: CoEffects.ambientGlow(
                  color: CoColors.primaryDim,
                  opacity: 0.18,
                  blur: 60,
                ),
              ),
            ),
            // Rotating gradient ring
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, child) {
                return Transform.rotate(angle: _ctrl.value * 6.28318530718, child: child);
              },
              child: Container(
                width: s,
                height: s,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: CoEffects.portalRingGradient,
                ),
              ),
            ),
            // Inner glass disc
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  width: s - 6,
                  height: s - 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CoColors.surfaceVariant.withValues(alpha: 0.55),
                  ),
                  alignment: Alignment.center,
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
