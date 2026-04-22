import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// **The "Hollow" Input**
///
/// 无背景填充，仅底部 Ghost Border + `headline-sm` 字号输入文本，
/// 保持神秘感「轻盈、空灵」的氛围。
class CoHollowInput extends StatelessWidget {
  const CoHollowInput({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final int? maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      textInputAction: textInputAction,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: CoTypography.headlineSm.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        // 主题已配置：底部 Ghost Border + `headline-sm` 字体。
      ),
    );
  }
}
