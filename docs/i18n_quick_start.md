# 多语言管理 - 快速开始

## 🚀 5 分钟快速上手

### 1. 修改 main.dart

使用 `Obx` 包裹 `MaterialApp.router` 并导入 `translation_service.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans; // ⚠️ 重要
import 'l10n/language_helper.dart';
import 'l10n/translation_service.dart';
import 'l10n/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<LanguageController>();
      return MaterialApp.router(
        locale: controller.currentLocale,
        // ... 其他配置见完整文档
        routerConfig: _appRouter.config(),
      );
    });
  }
}
```

### 2. 使用翻译 (推荐方式)

**导入：**
```dart
import 'package:get/get.dart' hide Trans;
import '../l10n/app_strings.dart';
import '../l10n/translation_service.dart';
```

**代码：**
```dart
// 使用 AppStrings 常量，支持自动补全
Text(AppStrings.loginTitle.tr)
```

## 📝 支持的语言

| 语言 | 代码 | 枚举值 |
|------|------|--------|
| 简体中文 | zh_CN | AppLanguage.zhCN |
| 繁体中文 | zh_TW | AppLanguage.zhTW |
| 英语 | en_US | AppLanguage.en |
| 日语 | ja_JP | AppLanguage.ja |

## 📁 文件结构

```
lib/l10n/
├── app_strings.dart          # 翻译 Key 常量 (类型安全) ✅
├── app_translations.dart     # 翻译文本
├── language_controller.dart  # 状态维护
├── language_helper.dart      # 快捷 API
└── translation_service.dart  # 路由兼容层 ✅
```

## ⚠️ 重要提示

1. **隐藏扩展冲突**
   导入 GetX 时使用 `hide Trans`。

2. **类型安全**
   优先使用 `AppStrings.xxx.tr` 而不是 `'xxx'.tr`。

3. **响应式更新**
   确保需要变化的 Widget 被 `Obx` 包裹。

## 🔗 完整文档

- **详细指南**: `docs/i18n_guide.md`
- **示例页面**: `lib/examples/language_settings_page.dart`
