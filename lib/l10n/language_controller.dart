import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';

/// 支持的语言枚举
enum AppLanguage {
  zhCN, // 简体中文
  zhTW, // 繁体中文
  en,   // 英语
  ja,   // 日语
}

/// 语言扩展方法
extension AppLanguageExtension on AppLanguage {
  /// 获取语言代码
  String get code {
    switch (this) {
      case AppLanguage.zhCN:
        return 'zh_CN';
      case AppLanguage.zhTW:
        return 'zh_TW';
      case AppLanguage.en:
        return 'en';
      case AppLanguage.ja:
        return 'ja';
    }
  }

  /// 获取语言名称
  String get name {
    switch (this) {
      case AppLanguage.zhCN:
        return '简体中文';
      case AppLanguage.zhTW:
        return '繁體中文';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.ja:
        return '日本語';
    }
  }

  /// 获取 Locale 对象
  Locale get locale {
    switch (this) {
      case AppLanguage.zhCN:
        return const Locale('zh', 'CN');
      case AppLanguage.zhTW:
        return const Locale('zh', 'TW');
      case AppLanguage.en:
        return const Locale('en', 'US');
      case AppLanguage.ja:
        return const Locale('ja', 'JP');
    }
  }

  /// 从语言代码创建枚举
  static AppLanguage fromCode(String code) {
    switch (code) {
      case 'zh_CN':
        return AppLanguage.zhCN;
      case 'zh_TW':
        return AppLanguage.zhTW;
      case 'en':
        return AppLanguage.en;
      case 'ja':
        return AppLanguage.ja;
      default:
        return AppLanguage.zhCN; // 默认简体中文
    }
  }

  /// 从 Locale 创建枚举
  static AppLanguage fromLocale(Locale locale) {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    if (languageCode == 'zh') {
      if (countryCode == 'TW' || countryCode == 'HK') {
        return AppLanguage.zhTW;
      }
      return AppLanguage.zhCN;
    } else if (languageCode == 'en') {
      return AppLanguage.en;
    } else if (languageCode == 'ja') {
      return AppLanguage.ja;
    }

    return AppLanguage.zhCN; // 默认简体中文
  }
}

/// 语言管理控制器
class LanguageController extends GetxController {
  // SharedPreferences 实例
  late SharedPreferences _prefs;

  // 当前语言（响应式）
  final currentLanguage = AppLanguage.zhCN.obs;

  // SharedPreferences 的键
  static const String _languageKey = 'app_language';

  @override
  void onInit() {
    super.onInit();
    _initLanguage();
  }

  /// 初始化语言设置
  Future<void> _initLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    
    // 从本地存储读取语言设置
    final savedLanguageCode = _prefs.getString(_languageKey);
    
    if (savedLanguageCode != null) {
      // 使用保存的语言
      currentLanguage.value = AppLanguageExtension.fromCode(savedLanguageCode);
    } else {
      // 使用系统语言
      final systemLocale = Get.deviceLocale;
      if (systemLocale != null) {
        currentLanguage.value = AppLanguageExtension.fromLocale(systemLocale);
      }
    }
    
    // 应用语言
    _applyLanguage(currentLanguage.value);
  }

  /// 切换语言
  Future<void> changeLanguage(AppLanguage language) async {
    Log.d("当前的语言为${language.code}");
    if (currentLanguage.value == language) return;

    currentLanguage.value = language;
    
    // 保存到本地存储
    await _prefs.setString(_languageKey, language.code);
    
    // 语言已切换，Obx 会自动重建 UI
    // 不需要手动调用 Get.updateLocale 或显示 snackbar
  }

  /// 应用语言设置
  void _applyLanguage(AppLanguage language) {
    // 只更新 currentLanguage，Obx 会自动处理 UI 更新
    // 不需要调用 Get.updateLocale
  }

  /// 获取所有支持的语言
  List<AppLanguage> get supportedLanguages => AppLanguage.values;

  /// 获取当前 Locale
  Locale get currentLocale => currentLanguage.value.locale;
}
