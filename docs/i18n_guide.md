# 多语言管理系统使用文档

## 目录
- [简介](#简介)
- [安装](#安装)
- [快速开始](#快速开始)
- [类型安全：AppStrings](#类型安全appstrings)
- [核心组件](#核心组件)
- [使用示例](#使用示例)
- [API 文档](#api-文档)
- [最佳实践](#最佳实践)

## 简介

基于 **GetX** 和 **intl** 的完整多语言管理解决方案，针对 **AutoRoute** 的 `MaterialApp.router` 进行了深度优化，支持：

- ✅ **类型安全**：使用 `AppStrings` 常量，支持 IDE 自动补全，避免拼写错误
- ✅ **4 种语言**：简体中文、繁体中文、英语、日语
- ✅ **动态切换**：运行时切换语言，UI 响应式更新
- ✅ **持久化存储**：使用 SharedPreferences 保存语言偏好
- ✅ **系统语言检测**：自动检测并使用系统语言
- ✅ **AutoRoute 兼容**：完美支持 `MaterialApp.router` 导航架构

## 安装

### 1. 依赖已添加

在 `pubspec.yaml` 中已添加：

```yaml
dependencies:
  get: ^4.6.6
  intl: ^0.20.2
  shared_preferences: ^2.2.2
  flutter_localizations:
    sdk: flutter
```

### 2. 安装依赖

```bash
flutter pub get
```

## 快速开始

### 1. 初始化应用

修改 `main.dart`，使用 `Obx` 包裹 `MaterialApp.router`：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart' hide Trans; // ⚠️ 重要：隐藏 GetX 的 Trans 扩展以避免冲突
import 'l10n/language_helper.dart';
import 'l10n/language_controller.dart';
import 'l10n/translation_service.dart';
import 'l10n/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化语言管理
  await LanguageHelper.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() {
      final currentLocale = languageController.currentLocale;
      
      return MaterialApp.router(
        title: 'Multi-Language Demo',
        
        // 1. 配置 Locale
        locale: currentLocale,
        
        // 2. 配置本地化代理
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        
        // 3. 配置支持的语言
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
          Locale('en', 'US'),
          Locale('ja', 'JP'),
        ],
        
        theme: ThemeData(useMaterial3: true),
        routerConfig: _appRouter.config(), // AutoRoute 配置
      );
    });
  }
}
```

### 2. 使用翻译

推荐导入 `translation_service.dart` 后使用 `AppStrings`：

```dart
import 'package:get/get.dart' hide Trans;
import '../l10n/app_strings.dart';
import '../l10n/translation_service.dart';

// ✅ 推荐：类型安全方式
Text(AppStrings.loginTitle.tr)

// ✅ 备选：字符串方式
Text('welcome'.tr)
```

## 类型安全：AppStrings

`AppStrings` 提供了所有翻译 Key 的常量定义，这是最推荐的使用方式。

### 优势
1. **自动补全**：IDE 会提示所有可用的翻译 Key
2. **避免语法错误**：不再担心 `welcom` 和 `welcome` 的拼写区别
3. **重构友好**：修改 Key 名称时，所有引用处自动更新

### 使用示例

```dart
// 认证
AppStrings.loginTitle.tr
AppStrings.username.tr

// 设置
AppStrings.language.tr
AppStrings.selectLanguage.tr

// 导航
AppStrings.home.tr
AppStrings.back.tr
```

## 核心组件

### 1. AppStrings (`lib/l10n/app_strings.dart`)
定义所有翻译 Key 为静态常量。

### 2. TranslationService (`lib/l10n/translation_service.dart`)
提供自定义的 `.tr` 扩展。由于我们使用了 `MaterialApp.router` 而不是 `GetMaterialApp`，必须使用此服务来衔接 GetX 的状态管理。

### 3. LanguageController (`lib/l10n/language_controller.dart`)
语言管理的核心，负责：
- 语言状态（响应式变量 `currentLanguage`）
- 持久化（SharedPreferences）

### 4. LanguageHelper (`lib/l10n/language_helper.dart`)
顶层工具类，提供快捷 API。

## 使用示例

### 基础翻译 (LoginPage)

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.loginTitle.tr),
      ),
      body: Column(
        children: [
          TextField(decoration: InputDecoration(labelText: AppStrings.username.tr)),
          TextField(decoration: InputDecoration(labelText: AppStrings.password.tr)),
          ElevatedButton(
            onPressed: () {},
            child: Text(AppStrings.login.tr),
          ),
        ],
      ),
    );
  }
}
```

### 响应式更新

如果某个 Widget 所在的页面没有被 `Obx` 整体包裹，但该 Widget 需要响应语言切换，请使用 `Obx` 单独包裹：

```dart
Obx(() => Text(AppStrings.welcome.tr))
```

## API 文档

### LanguageHelper API

| 方法 | 说明 |
|------|------|
| `init()` | 初始化系统 |
| `changeLanguage(AppLanguage)` | 切换语言 |
| `switchToNextLanguage()` | 轮显语言 |
| `currentLanguage` | 获取当前语言枚举 |
| `currentLocale` | 获取当前 Locale 对象 |

### AppLanguage 枚举

- `zhCN`: 简体中文
- `zhTW`: 繁体中文
- `en`: 英语
- `ja`: 日语

## 最佳实践

### 1. 隐藏 GetX 的 Trans 扩展
为了让我们的自定义 `.tr` 生效并保持类型安全，在任何使用翻译的文件中，导入 GetX 时请务必：

```dart
import 'package:get/get.dart' hide Trans;
```

### 2. 集中管理 Key
所有新的翻译 Key 都应该先添加到 `AppStrings` 类中，然后再在 `AppTranslations` 中添加对应的翻译文本。

### 3. 命名规范
- **Key**: 使用驼峰命名，如 `loginSuccessMessage`
- **常量名**: 与 Key 保持一致

### 4. 在 Obx 中访问响应式变量
如果在 `Obx` 中只调用了 `.tr` 而没有直接访问控制器变量，某些情况下 GetX 可能会由于没有检测到观察点而不更新。建议显式访问一次变量：

```dart
Obx(() {
  // 显式访问让 GetX 追踪
  final lang = Get.find<LanguageController>().currentLanguage.value;
  return Text(AppStrings.test.tr);
});
```

## 常见问题

### Q1: 切换语言后 UI 没变化？
**A**: 
1. 检查是否导入了 `translation_service.dart`。
2. 确保使用了 `Obx` 包裹。
3. 确保在 `main.dart` 中最外层的 `MaterialApp.router` 被 `Obx` 包裹了。

### Q2: 出现 "Member named 'tr' is defined in both..." 错误？
**A**: 这是扩展冲突。请在导入 `get` 时加上 `hide Trans`。

## 文件结构

```
lib/l10n/
├── app_strings.dart          # 翻译 Key 常量 (类型安全)
├── app_translations.dart     # 翻译文本内容
├── language_controller.dart  # 状态维护
├── language_helper.dart      # 快捷 API
└── translation_service.dart  # 路由兼容层
```

---
最后更新：2026-01-28
