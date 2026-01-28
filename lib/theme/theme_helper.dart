import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

/// 主题管理工具类
class ThemeHelper {
  ThemeHelper._();

  /// 初始化主题管理
  static void init() {
    Get.put(ThemeController());
  }

  /// 获取主题控制器
  static ThemeController get _controller {
    try {
      return Get.find<ThemeController>();
    } catch (e) {
      return Get.put(ThemeController());
    }
  }

  /// 获取当前主题模式
  static AppThemeMode get currentMode => _controller.themeMode.value;

  /// 设置主题模式
  static Future<void> setThemeMode(AppThemeMode mode) async {
    await _controller.setThemeMode(mode);
  }

  /// 切换主题（亮色/暗色互换）
  static Future<void> toggleTheme() async {
    await _controller.toggleTheme();
  }

  /// 是否为暗色模式
  static bool get isDarkMode => _controller.isDarkMode;

  /// 获取当前生效的 ThemeMode (用于 MaterialApp)
  static ThemeMode get themeMode => _controller.getThemeMode();
}
