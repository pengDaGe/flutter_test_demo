# 多语言管理系统

基于 **GetX** 和 **intl** 的完整多语言国际化解决方案，专为 `MaterialApp.router` (AutoRoute) 优化。

## ✨ 特性

- ✅ **4 种语言支持** (中简、中繁、英、日)
- ✅ **类型安全** (`AppStrings` 常量管理)
- ✅ **动态语言切换** (响应式 UI 更新)
- ✅ **持久化存储** (用户偏好自动保存)
- ✅ **AutoRoute 兼容** (支持路由架构)

## 🚀 快速集成

### 1. 配置入口

```dart
// main.dart
return Obx(() => MaterialApp.router(
  locale: Get.find<LanguageController>().currentLocale,
  // ...
));
```

### 2. 使用 AppStrings

```dart
import '../l10n/app_strings.dart';
import '../l10n/translation_service.dart';

Text(AppStrings.welcome.tr);
```

## 📝 核心 API

| 类 | 说明 |
|----|------|
| `AppStrings` | 类型安全的翻译 Key 常量集 |
| `LanguageHelper` | 提供 `changeLanguage`, `init` 等快捷方法 |
| `TranslationService` | 在路由架构下衔接 GetX 翻译功能的兼容层 |

## 📖 文档

- **[快速开始](i18n_quick_start.md)** - 5 分钟上手
- **[完整指南](i18n_guide.md)** - 详细配置与 API 文档

## ⚠️ 注意事项

- **导入 GetX 时**: 请使用 `import 'package:get/get.dart' hide Trans;`
- **翻译更新**: 必须导入 `translation_service.dart` 才能使用 `.tr` 扩展。
- **类型安全**: 强烈建议使用 `AppStrings` 常量，避免拼写错误导致翻译失效。
