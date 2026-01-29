import 'package:flutter/material.dart';

/// 社交登录按钮
class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? border;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          side: border ?? const BorderSide(color: Color(0xFFEEEEEE), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
