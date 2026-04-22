import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// 模式选择 Chip。被选中后请通过外层 `Theme` 切换全局 accent。
class CoModeChip extends StatelessWidget {
  const CoModeChip({
    super.key,
    required this.label,
    required this.mode,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final CoAccentMode mode;
  final bool selected;
  final ValueChanged<CoAccentMode> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color accent = CoColors.accentForMode(mode);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: selected ? CoColors.onPrimary : CoColors.onSurfaceVariant,
            ),
            const SizedBox(width: CoSpacing.xs),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      selectedColor: accent,
      backgroundColor: CoColors.surfaceContainerLow,
      labelStyle: CoTypography.labelMd.copyWith(
        color: selected ? CoColors.onPrimary : CoColors.onSurface,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      onSelected: (v) {
        if (v) onSelected(mode);
      },
    );
  }
}

/// 一组模式 Chip。展示水平滚动选择，并向上回调切换 accent。
class CoModeChipBar extends StatelessWidget {
  const CoModeChipBar({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final CoAccentMode current;
  final ValueChanged<CoAccentMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: CoSpacing.lg),
      child: Row(
        children: [
          CoModeChip(
            label: 'Oracle',
            mode: CoAccentMode.oracle,
            selected: current == CoAccentMode.oracle,
            onSelected: onChanged,
          ),
          const SizedBox(width: CoSpacing.sm),
          CoModeChip(
            label: 'Savage',
            mode: CoAccentMode.savage,
            selected: current == CoAccentMode.savage,
            onSelected: onChanged,
          ),
          const SizedBox(width: CoSpacing.sm),
          CoModeChip(
            label: 'Wealth',
            mode: CoAccentMode.wealth,
            selected: current == CoAccentMode.wealth,
            onSelected: onChanged,
          ),
        ],
      ),
    );
  }
}
