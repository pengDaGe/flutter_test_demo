# LanguageSettingsPage 路由配置完成

## ✅ 已完成的配置

成功将 `LanguageSettingsPage` 添加到 AutoRoute 路由管理中。

## 📝 修改内容

### 1. 添加导入

**文件**: `lib/router/app_router.dart`

```dart
import '../examples/language_settings_page.dart';
```

### 2. 添加路由配置

**文件**: `lib/router/app_router.dart`

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 闪屏页
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
      path: '/',
    ),
    
    // 主页
    AutoRoute(
      page: MyHomeRoute.page,
      path: '/home',
    ),
    
    // GetX 计数器示例页面
    AutoRoute(
      page: CounterRoute.page,
      path: '/counter',
    ),
    
    // 语言设置页面 ✅ 新增
    AutoRoute(
      page: LanguageSettingsRoute.page,
      path: '/language-settings',
    ),
  ];
}
```

## 🚀 下一步：生成路由代码

### 必须运行代码生成命令

```bash
dart run build_runner build --delete-conflicting-outputs
```

或者使用 watch 模式（自动监听文件变化）：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 📱 使用方式

### 1. 使用 RouterHelper

```dart
import 'package:flutter_test_demo/router/app_router.dart';
import 'package:flutter_test_demo/utils/router_helper.dart';

// 跳转到语言设置页面
RouterHelper.push(LanguageSettingsRoute());

// 或使用路径
RouterHelper.push('/language-settings');
```

### 2. 使用 context.router

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter_test_demo/router/app_router.dart';

// 跳转到语言设置页面
context.router.push(LanguageSettingsRoute());

// 返回
context.router.pop();
```

### 3. 在按钮中使用

```dart
ElevatedButton(
  onPressed: () {
    RouterHelper.push(LanguageSettingsRoute());
  },
  child: Text('语言设置'),
)
```

### 4. 在 AppBar 中使用

```dart
AppBar(
  title: Text('首页'),
  actions: [
    IconButton(
      icon: Icon(Icons.language),
      onPressed: () {
        context.router.push(LanguageSettingsRoute());
      },
    ),
  ],
)
```

## 🎨 完整示例

### 在主页添加语言设置按钮

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_test_demo/router/app_router.dart';
import 'package:flutter_test_demo/l10n/translation_service.dart';

@RoutePage()
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          // 语言设置按钮
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'settings'.tr,
            onPressed: () {
              context.router.push(LanguageSettingsRoute());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.router.push(LanguageSettingsRoute());
              },
              child: Text('language'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📋 路由列表

当前应用的所有路由：

| 路由名称 | 路径 | 页面 | 说明 |
|---------|------|------|------|
| SplashRoute | `/` | SplashPage | 闪屏页（初始路由） |
| MyHomeRoute | `/home` | MyHomePage | 主页 |
| CounterRoute | `/counter` | CounterPage | GetX 计数器示例 |
| LanguageSettingsRoute | `/language-settings` | LanguageSettingsPage | 语言设置页面 ✅ |

## 🔧 路由功能

### 基本导航

```dart
// 跳转
context.router.push(LanguageSettingsRoute());

// 返回
context.router.pop();

// 替换当前路由
context.router.replace(LanguageSettingsRoute());

// 跳转并清空堆栈
context.router.pushAndPopUntil(
  LanguageSettingsRoute(),
  predicate: (route) => false,
);
```

### 路径导航

```dart
// 使用路径跳转
RouterHelper.push('/language-settings');

// 带参数
RouterHelper.push('/language-settings?theme=dark');
```

### 嵌套导航

```dart
// 在嵌套路由中使用
context.router.navigate(LanguageSettingsRoute());
```

## ⚠️ 重要提示

### 1. 必须运行代码生成

修改路由配置后，**必须**运行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

否则会出现编译错误。

### 2. 检查生成的文件

生成后会创建/更新：

```
lib/router/app_router.gr.dart
```

### 3. LanguageSettingsPage 已有 @RoutePage

```dart
@RoutePage()  // ✅ 已存在
class LanguageSettingsPage extends StatelessWidget {
  ...
}
```

### 4. 导入 TranslationService

在使用 `.tr` 的页面中导入：

```dart
import 'package:flutter_test_demo/l10n/translation_service.dart';
```

## 🎯 测试步骤

### 1. 生成路由代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. 运行应用

```bash
flutter run
```

### 3. 测试导航

```dart
// 在任何页面添加按钮
ElevatedButton(
  onPressed: () {
    context.router.push(LanguageSettingsRoute());
  },
  child: Text('打开语言设置'),
)
```

### 4. 测试功能

- ✅ 点击按钮跳转到语言设置页面
- ✅ 在语言设置页面切换语言
- ✅ 点击返回按钮返回上一页
- ✅ 翻译文本自动更新

## 📚 相关文档

- **AutoRoute 文档**: `COUNTER_ROUTE_SETUP.md`
- **多语言文档**: `docs/i18n_guide.md`
- **集成文档**: `GETX_AUTOROUTE_INTEGRATION.md`

## 💡 最佳实践

### 1. 使用类型安全的路由

```dart
// ✅ 推荐：类型安全
context.router.push(LanguageSettingsRoute());

// ❌ 不推荐：字符串路径（容易出错）
context.router.push('/language-settings');
```

### 2. 使用 RouterHelper

```dart
// ✅ 推荐：统一的路由管理
RouterHelper.push(LanguageSettingsRoute());

// ✅ 也可以：直接使用 context.router
context.router.push(LanguageSettingsRoute());
```

### 3. 处理返回值

```dart
// 跳转并等待返回值
final result = await context.router.push(LanguageSettingsRoute());
if (result != null) {
  print('返回值: $result');
}
```

## 🎉 完成

- ✅ LanguageSettingsPage 已添加到路由配置
- ✅ 路由路径: `/language-settings`
- ✅ 可以使用 `LanguageSettingsRoute()` 导航
- ✅ 支持所有 AutoRoute 功能

**下一步：运行 `dart run build_runner build --delete-conflicting-outputs` 生成路由代码！**
