import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_controller.dart';

/// 语言管理工具类
/// 提供简洁的 API 用于语言切换和翻译
class LanguageHelper {
  LanguageHelper._();

  /// 初始化语言管理
  /// 在 main() 函数中调用
  static Future<void> init() async {
    // 注册语言控制器
    Get.put(LanguageController());
  }

  /// 获取语言控制器
  static LanguageController get _controller {
    try {
      return Get.find<LanguageController>();
    } catch (e) {
      // 如果控制器未注册，先注册
      return Get.put(LanguageController());
    }
  }

  /// 获取当前语言
  static AppLanguage get currentLanguage => _controller.currentLanguage.value;

  /// 获取当前 Locale
  static Locale get currentLocale => _controller.currentLocale;

  /// 切换语言
  /// 
  /// 示例:
  /// ```dart
  /// LanguageHelper.changeLanguage(AppLanguage.en);
  /// ```
  static Future<void> changeLanguage(AppLanguage language) async {
    await _controller.changeLanguage(language);
  }

  /// 获取所有支持的语言
  static List<AppLanguage> get supportedLanguages =>
      _controller.supportedLanguages;

  /// 翻译文本
  /// 
  /// 示例:
  /// ```dart
  /// String title = LanguageHelper.tr('loginTitle');
  /// ```
  static String tr(String key) {
    return key.tr;
  }

  /// 带参数的翻译
  /// 
  /// 示例:
  /// ```dart
  /// String message = LanguageHelper.trParams('welcome', {'name': 'John'});
  /// ```
  static String trParams(String key, Map<String, String> params) {
    return key.trParams(params);
  }

  /// 带复数的翻译
  /// 
  /// 示例:
  /// ```dart
  /// String message = LanguageHelper.trPlural('item', 5);
  /// ```
  static String trPlural(String key, int count) {
    return key.trPlural(count.toString());
  }

  /// 检查是否为简体中文
  static bool get isZhCN => currentLanguage == AppLanguage.zhCN;

  /// 检查是否为繁体中文
  static bool get isZhTW => currentLanguage == AppLanguage.zhTW;

  /// 检查是否为英语
  static bool get isEnglish => currentLanguage == AppLanguage.en;

  /// 检查是否为日语
  static bool get isJapanese => currentLanguage == AppLanguage.ja;

  /// 检查是否为中文（简体或繁体）
  static bool get isChinese => isZhCN || isZhTW;

  /// 获取语言名称
  static String getLanguageName(AppLanguage language) {
    return language.name;
  }

  /// 获取当前语言名称
  static String get currentLanguageName => currentLanguage.name;

  /// 切换到下一个语言
  static Future<void> switchToNextLanguage() async {
    final languages = supportedLanguages;
    final currentIndex = languages.indexOf(currentLanguage);
    final nextIndex = (currentIndex + 1) % languages.length;
    await changeLanguage(languages[nextIndex]);
  }

  /// 切换到上一个语言
  static Future<void> switchToPreviousLanguage() async {
    final languages = supportedLanguages;
    final currentIndex = languages.indexOf(currentLanguage);
    final previousIndex =
        (currentIndex - 1 + languages.length) % languages.length;
    await changeLanguage(languages[previousIndex]);
  }

  /// 根据语言代码切换语言
  static Future<void> changeLanguageByCode(String code) async {
    final language = AppLanguageExtension.fromCode(code);
    await changeLanguage(language);
  }

  /// 根据 Locale 切换语言
  static Future<void> changeLanguageByLocale(Locale locale) async {
    final language = AppLanguageExtension.fromLocale(locale);
    await changeLanguage(language);
  }

  /// 重置为系统语言
  static Future<void> resetToSystemLanguage() async {
    final systemLocale = Get.deviceLocale;
    if (systemLocale != null) {
      await changeLanguageByLocale(systemLocale);
    }
  }
}

/// 扩展方法，方便在 Widget 中使用
extension TranslationExtension on String {
  /// 翻译当前字符串
  String get i18n => LanguageHelper.tr(this);

  /// 带参数的翻译
  String i18nParams(Map<String, String> params) =>
      LanguageHelper.trParams(this, params);

  /// 带复数的翻译
  String i18nPlural(int count) => LanguageHelper.trPlural(this, count);
}
