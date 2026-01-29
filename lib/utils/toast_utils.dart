import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

/// Toast 工具类
class ToastUtils {
  ToastUtils._();

  /// 初始化 Toast 配置
  /// 在 main.dart 中包装 OKToast
  static Widget init(Widget child) {
    return OKToast(
      /// 默认居中显示
      position: ToastPosition.center,
      /// 默认样式配置
      backgroundColor: Colors.black.withOpacity(0.8),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      radius: 8.0,
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: child,
    );
  }

  /// 显示普通消息
  static void show(String msg, {ToastPosition? position}) {
    if (msg.isEmpty) return;
    showToast(
      msg,
      position: position ?? ToastPosition.center,
    );
  }

  /// 显示成功消息
  static void showSuccess(String msg) {
    show(msg);
  }

  /// 显示错误消息
  static void showError(String msg) {
    show(msg);
  }
}
