# GetX + AutoRoute 集成方案

## 问题

`GetMaterialApp` 不支持 `routerConfig` 参数，无法直接与 AutoRoute 的 `router` 模式集成。

## 解决方案

使用 `MaterialApp.router` + 自定义翻译服务 + GetX 状态管理。

## 实现方式

### 1. 文件结构

```
lib/
├── l10n/
│   ├── language_controller.dart    # 语言控制器
│   ├── app_translations.dart       # 翻译数据
│   ├── language_helper.dart        # 语言工具类
│   └── translation_service.dart    # 翻译服务（新增）
├── router/
│   └── app_router.dart
└── main.dart
```

### 2. TranslationService (新增)

**文件**: `lib/l10n/translation_service.dart`

提供 `.tr` 翻译功能，即使在 `MaterialApp.router` 中也能使用：

```dart
import 'package:get/get.dart';
import 'language_controller.dart';
import 'app_translations.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final _translations = AppTranslations().keys;

  String tr(String key, {Map<String, String>? params}) {
    final languageController = Get.find<LanguageController>();
    final locale = languageController.currentLocale;
    final languageCode = '${locale.languageCode}_${locale.countryCode}';
    
    String? translation = _translations[languageCode]?[key];
    translation ??= _translations['zh_CN']?[key];
    translation ??= key;
    
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation!.replaceAll('@$paramKey', paramValue);
      });
    }
    
    return translation;
  }
}

extension StringTranslationExtension on String {
  String get tr => TranslationService().tr(this);
  String trParams(Map<String, String> params) => TranslationService().tr(this, params: params);
}
```

### 3. main.dart 配置

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'l10n/language_controller.dart';
import 'l10n/language_helper.dart';
import 'l10n/translation_service.dart';
import 'router/app_router.dart';
import 'utils/router_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    RouterHelper.init(_appRouter);
    final languageController = Get.find<LanguageController>();
    
    // 使用 Obx 监听语言变化
    return Obx(() {
      // 更新 GetX 的 locale
      Get.updateLocale(languageController.currentLocale);
      
      return MaterialApp.router(
        title: 'Flutter Demo',
        
        // 语言配置
        locale: languageController.currentLocale,
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
          Locale('en', 'US'),
          Locale('ja', 'JP'),
        ],
        
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        
        // AutoRoute 路由配置
        routerConfig: _appRouter.config(),
      );
    });
  }
}
```

## 使用方式

### 1. 翻译文本

```dart
// 在任何 Widget 中使用 .tr
Text('loginTitle'.tr)  // 登录 / Login / ログイン / 登錄

// 带参数
Text('welcome'.trParams({'name': 'John'}))
```

### 2. 语言切换

```dart
// 切换语言
await LanguageHelper.changeLanguage(AppLanguage.en);

// 切换到日语
await LanguageHelper.changeLanguage(AppLanguage.ja);
```

### 3. 路由导航

```dart
// 使用 RouterHelper
RouterHelper.push(CounterRoute());

// 使用 context.router
context.router.push(CounterRoute());
```

### 4. GetX 功能

```dart
// SnackBar
Get.snackbar('成功', '操作完成');

// Dialog
Get.dialog(AlertDialog(...));

// 状态管理
final controller = Get.put(MyController());
```

## 工作原理

### 1. 语言管理

- ✅ 使用 GetX 的 `LanguageController` 管理语言状态
- ✅ 使用 `Obx` 监听语言变化
- ✅ 语言切换时自动重建 UI

### 2. 翻译功能

- ✅ `TranslationService` 提供 `.tr` 扩展方法
- ✅ 从 `AppTranslations` 读取翻译数据
- ✅ 支持参数替换

### 3. 路由管理

- ✅ 使用 `MaterialApp.router` 支持 AutoRoute
- ✅ 使用 `routerConfig` 配置路由
- ✅ 保持 AutoRoute 的所有功能

### 4. 状态管理

- ✅ GetX 的所有功能可用（Get.snackbar, Get.dialog 等）
- ✅ 响应式状态管理
- ✅ 依赖注入

## 优势

### vs GetMaterialApp.router (不存在)

| 特性 | GetMaterialApp.router | 我们的方案 |
|------|----------------------|-----------|
| 存在性 | ❌ 不存在 | ✅ 可用 |
| AutoRoute 支持 | ❌ | ✅ |
| GetX 功能 | ❌ | ✅ |
| 多语言 | ❌ | ✅ |

### vs GetMaterialApp (无路由)

| 特性 | GetMaterialApp | 我们的方案 |
|------|---------------|-----------|
| AutoRoute 支持 | ❌ | ✅ |
| GetX 功能 | ✅ | ✅ |
| 多语言 | ✅ | ✅ |
| 路由配置 | 简单 | 需要 routerConfig |

## 完整示例

### 带多语言的页面

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import '../l10n/translation_service.dart';  // 导入翻译服务
import '../l10n/language_helper.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),  // 使用 .tr 翻译
        actions: [
          // 语言切换按钮
          PopupMenuButton<AppLanguage>(
            icon: Icon(Icons.language),
            onSelected: (lang) => LanguageHelper.changeLanguage(lang),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AppLanguage.zhCN,
                child: Text('简体中文'),
              ),
              PopupMenuItem(
                value: AppLanguage.zhTW,
                child: Text('繁體中文'),
              ),
              PopupMenuItem(
                value: AppLanguage.en,
                child: Text('English'),
              ),
              PopupMenuItem(
                value: AppLanguage.ja,
                child: Text('日本語'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr),
            Text('loginTitle'.tr),
            ElevatedButton(
              onPressed: () {
                context.router.push(CounterRoute());
              },
              child: Text('settings'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 注意事项

### 1. 必须导入 TranslationService

在使用 `.tr` 的文件中导入：

```dart
import 'package:flutter_test_demo/l10n/translation_service.dart';
```

### 2. 响应式更新

语言切换会自动触发 UI 更新，因为使用了 `Obx`。

### 3. GetX 功能

所有 GetX 功能都可用：
- Get.snackbar
- Get.dialog
- Get.bottomSheet
- Get.put / Get.find
- Obx / GetBuilder

### 4. AutoRoute 功能

所有 AutoRoute 功能都可用：
- 声明式路由
- 路由守卫
- 深度链接
- 路由参数

## 总结

这个方案完美结合了：

- ✅ **AutoRoute** - 强大的路由管理
- ✅ **GetX** - 状态管理和工具函数
- ✅ **多语言** - 自定义翻译服务
- ✅ **响应式** - 语言切换自动更新

**最佳实践：MaterialApp.router + GetX + 自定义翻译服务** 🎉
