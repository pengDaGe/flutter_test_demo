import 'package:flutter/material.dart';

import '../../theme/cyber_oracle/cyber_oracle.dart';

/// 「编辑性」非对称段落容器：左侧大标题、右下角小型 sarcasm/context。
class CoEditorialSection extends StatelessWidget {
  const CoEditorialSection({
    super.key,
    required this.headline,
    this.context_,
    this.headlineStyle,
    this.contextStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: CoSpacing.lg),
  });

  /// 主标题（神谕之声）。默认 `displaySm`。
  final String headline;

  /// 右下角的小注释 / sarcasm。可省略。
  final String? context_;

  final TextStyle? headlineStyle;
  final TextStyle? contextStyle;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headline,
            style: headlineStyle ?? CoTypography.displaySm,
          ),
          if (context_ != null) ...[
            const SizedBox(height: CoSpacing.sm),
            Align(
              alignment: Alignment.bottomRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  context_!,
                  textAlign: TextAlign.right,
                  style: contextStyle ?? CoTypography.bodySm,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
