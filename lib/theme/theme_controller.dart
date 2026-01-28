import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题管理模式枚举
enum AppThemeMode {
  light,
  dark,
  system,
}

/// 主题管理控制器
class ThemeController extends GetxController {
  late SharedPreferences _prefs;
  static const String _themeKey = 'app_theme_mode';

  // 当前主题模式（响应式）
  final themeMode = AppThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _initTheme();
  }

  /// 初始化主题设置
  Future<void> _initTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final savedMode = _prefs.getString(_themeKey);
    
    if (savedMode != null) {
      themeMode.value = AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedMode,
        orElse: () => AppThemeMode.system,
      );
    }
  }

  /// 切换主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (themeMode.value == mode) return;
    
    themeMode.value = mode;
    await _prefs.setString(_themeKey, mode.toString());
    
    // 使用 Get.changeThemeMode 立即应用主题
    Get.changeThemeMode(getThemeMode());
  }

  /// 获取 Flutter 原生 ThemeMode
  ThemeMode getThemeMode() {
    switch (themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// 获取当前模式是否为暗色模式
  bool get isDarkMode {
    if (themeMode.value == AppThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode.value == AppThemeMode.dark;
  }

  /// 快速切换亮色/暗色模式
  Future<void> toggleTheme() async {
    if (isDarkMode) {
      await setThemeMode(AppThemeMode.light);
    } else {
      await setThemeMode(AppThemeMode.dark);
    }
  }
}
