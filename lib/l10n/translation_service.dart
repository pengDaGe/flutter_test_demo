import 'package:get/get.dart';
import 'language_controller.dart';
import 'app_translations.dart';

/// 翻译服务类
/// 用于在 MaterialApp.router 中提供 GetX 风格的翻译功能
class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  // 翻译数据
  final _translations = AppTranslations().keys;

  /// 获取翻译文本
  String tr(String key, {Map<String, String>? params}) {
    final languageController = Get.find<LanguageController>();
    final locale = languageController.currentLocale;
    final languageCode = '${locale.languageCode}_${locale.countryCode}';
    
    // 获取翻译
    String? translation = _translations[languageCode]?[key];
    
    // 如果没有找到，使用简体中文作为后备
    translation ??= _translations['zh_CN']?[key];
    
    // 如果还是没有，返回 key 本身
    translation ??= key;
    
    // 替换参数
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation!.replaceAll('@$paramKey', paramValue);
      });
    }
    
    return translation!;
  }
}

/// 扩展 String 类，添加 tr 方法
extension StringTranslationExtension on String {
  /// 翻译当前字符串
  String get tr {
    return TranslationService().tr(this);
  }
  
  /// 带参数的翻译
  String trParams(Map<String, String> params) {
    return TranslationService().tr(this, params: params);
  }
}
