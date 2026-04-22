import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// **Primary - The Action**
///
/// `primary` 填充按钮，最高对比度。可选 [withGlow] 添加 Ambient Glow。
class CoPrimaryButton extends StatelessWidget {
  const CoPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.withGlow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool withGlow;

  @override
  Widget build(BuildContext context) {
    final Widget button = FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
    );

    final Widget child = expand
        ? SizedBox(width: double.infinity, child: button)
        : button;

    if (!withGlow) return child;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CoRadius.sm),
        boxShadow: CoEffects.ambientGlow(
          color: Theme.of(context).colorScheme.primary,
          opacity: 0.18,
        ),
      ),
      child: child,
    );
  }
}

/// **Secondary - The Choice**
///
/// Glassmorphism 背景 + Primary 「Ghost Border」(20% opacity)。
class CoSecondaryButton extends StatelessWidget {
  const CoSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;

    final Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(CoRadius.sm),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: CoColors.surfaceVariant.withValues(alpha: 0.30),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CoSpacing.lg,
                vertical: CoSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: accent),
                    const SizedBox(width: CoSpacing.sm),
                  ],
                  Text(label, style: CoTypography.labelLg.copyWith(color: accent)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final Widget bordered = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CoRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: content,
    );

    return expand ? SizedBox(width: double.infinity, child: bordered) : bordered;
  }
}

/// **Tertiary - The Subtle**
///
/// 纯文本，无背景。使用 [CoColors.primaryFixed]。
class CoTertiaryButton extends StatelessWidget {
  const CoTertiaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(label));
  }
}
