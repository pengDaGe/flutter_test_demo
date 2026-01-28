# Flutter 本地化支持修复

## 问题描述

运行应用时出现警告：

```
Warning: This application's locale, zh_CN, is not supported by all of its localization delegates.

• A MaterialLocalizations delegate that supports the zh_CN locale was not found.
• A CupertinoLocalizations delegate that supports the zh_CN locale was not found.
```

## 原因

Flutter 应用需要本地化代理（Localization Delegates）来支持不同语言的 Material 和 Cupertino 组件。

## 解决方案

### 1. 添加依赖

**文件**: `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:  # 添加本地化支持
    sdk: flutter
```

### 2. 导入本地化包

**文件**: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  // 新增
```

### 3. 添加本地化代理

**文件**: `lib/main.dart`

```dart
return MaterialApp.router(
  locale: languageController.currentLocale,
  
  // 添加本地化代理
  localizationsDelegates: const [
    // Material 组件本地化
    GlobalMaterialLocalizations.delegate,
    // Cupertino 组件本地化
    GlobalCupertinoLocalizations.delegate,
    // Widgets 本地化
    GlobalWidgetsLocalizations.delegate,
  ],
  
  supportedLocales: const [
    Locale('zh', 'CN'),  // 简体中文
    Locale('zh', 'TW'),  // 繁体中文
    Locale('en', 'US'),  // 英语
    Locale('ja', 'JP'),  // 日语
  ],
  
  routerConfig: _appRouter.config(),
);
```

## 本地化代理说明

### GlobalMaterialLocalizations.delegate

- 提供 Material Design 组件的本地化
- 包括按钮、对话框、日期选择器等的文本
- 支持多种语言

### GlobalCupertinoLocalizations.delegate

- 提供 Cupertino (iOS 风格) 组件的本地化
- 包括 iOS 风格的按钮、对话框等
- 支持多种语言

### GlobalWidgetsLocalizations.delegate

- 提供基础 Widget 的本地化
- 包括文本方向、默认文本样式等
- 是其他本地化代理的基础

## 支持的语言

添加本地化代理后，以下组件会自动使用对应语言：

### 简体中文 (zh_CN)

```dart
// 日期选择器
showDatePicker(...)  // 显示中文月份和星期

// 对话框
showDialog(...)      // "确定"、"取消" 按钮

// 时间选择器
showTimePicker(...)  // 中文时间格式
```

### 繁体中文 (zh_TW)

```dart
// 同样支持繁体中文的组件文本
```

### 英语 (en_US)

```dart
// 日期选择器
showDatePicker(...)  // 显示英文月份和星期

// 对话框
showDialog(...)      // "OK", "Cancel" 按钮
```

### 日语 (ja_JP)

```dart
// 日期选择器
showDatePicker(...)  // 显示日文月份和星期

// 对话框
showDialog(...)      // "OK", "キャンセル" 按钮
```

## 完整配置示例

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    RouterHelper.init(_appRouter);
    final languageController = Get.find<LanguageController>();
    
    return Obx(() {
      Get.updateLocale(languageController.currentLocale);
      
      return MaterialApp.router(
        title: 'Flutter Demo',
        
        // 语言配置
        locale: languageController.currentLocale,
        
        // 本地化代理
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        
        // 支持的语言
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
        
        routerConfig: _appRouter.config(),
      );
    });
  }
}
```

## 验证步骤

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 运行应用

```bash
flutter run
```

### 3. 测试本地化

```dart
// 测试日期选择器
ElevatedButton(
  onPressed: () async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  },
  child: Text('选择日期'),
)
```

切换语言后，日期选择器的文本应该自动更新。

## 效果

### 修复前

```
⚠️ Warning: This application's locale, zh_CN, is not supported...
```

### 修复后

```
✅ 无警告，所有组件正确显示本地化文本
```

## 支持的组件

添加本地化代理后，以下组件会自动本地化：

- ✅ **DatePicker** - 日期选择器
- ✅ **TimePicker** - 时间选择器
- ✅ **Dialog** - 对话框按钮
- ✅ **Drawer** - 抽屉菜单
- ✅ **Pagination** - 分页控件
- ✅ **DataTable** - 数据表格
- ✅ **Tooltip** - 工具提示
- ✅ **SnackBar** - 提示条
- ✅ **TextField** - 文本输入框错误提示

## 注意事项

### 1. 必须添加 flutter_localizations

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

### 2. 必须导入包

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
```

### 3. 必须添加三个代理

```dart
localizationsDelegates: const [
  GlobalMaterialLocalizations.delegate,      // 必需
  GlobalCupertinoLocalizations.delegate,     // 必需
  GlobalWidgetsLocalizations.delegate,       // 必需
],
```

### 4. supportedLocales 必须匹配

```dart
supportedLocales: const [
  Locale('zh', 'CN'),  // 必须与 locale 匹配
  Locale('zh', 'TW'),
  Locale('en', 'US'),
  Locale('ja', 'JP'),
],
```

## 常见问题

### Q1: 仍然显示警告？

A: 确保：
1. 已运行 `flutter pub get`
2. 已重启应用
3. 三个代理都已添加

### Q2: 某些组件没有本地化？

A: 检查：
1. `supportedLocales` 是否包含该语言
2. 是否添加了所有三个代理
3. Flutter 版本是否支持该语言

### Q3: 如何添加更多语言？

A: 在 `supportedLocales` 中添加：

```dart
supportedLocales: const [
  Locale('zh', 'CN'),
  Locale('zh', 'TW'),
  Locale('en', 'US'),
  Locale('ja', 'JP'),
  Locale('ko', 'KR'),  // 韩语
  Locale('fr', 'FR'),  // 法语
],
```

## 总结

- ✅ 添加 `flutter_localizations` 依赖
- ✅ 导入 `flutter_localizations` 包
- ✅ 添加三个本地化代理
- ✅ 配置 `supportedLocales`
- ✅ 所有 Flutter 组件自动本地化

**本地化支持已完成！** 🎉
