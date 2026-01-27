# ✅ 路由配置错误已修复

## 🐛 问题说明

### 错误代码
```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashPage.page,  // ❌ 错误：SplashPage 没有 .page 属性
      initial: true,
      path: '/',
    ),
    AutoRoute(
      page: MyHomePage.page,  // ❌ 错误：MyHomePage 没有 .page 属性
      path: '/home',
    ),
  ];
}
```

### 错误原因

`SplashPage` 和 `MyHomePage` 是**页面类**，不是**路由类**。

在 AutoRoute 中：
- **页面类**：实际的 Widget（如 `SplashPage`、`MyHomePage`）
- **路由类**：由代码生成器创建的路由包装类（如 `SplashRoute`、`MyHomeRoute`）

只有**路由类**才有 `.page` 属性！

## ✅ 修复方案

### 正确代码
```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,  // ✅ 正确：使用生成的路由类
      initial: true,
      path: '/',
    ),
    AutoRoute(
      page: MyHomeRoute.page,  // ✅ 正确：使用生成的路由类
      path: '/home',
    ),
  ];
}
```

## 📋 页面类 vs 路由类对照表

| 页面类（Widget） | 路由类（生成的） | 文件位置 |
|----------------|----------------|---------|
| `SplashPage` | `SplashRoute` | `app_router.gr.dart` |
| `MyHomePage` | `MyHomeRoute` | `app_router.gr.dart` |

## 🔍 如何找到正确的路由类名？

### 方法 1: 查看生成的文件

打开 `lib/router/app_router.gr.dart`，查找生成的路由类：

```dart
// lib/router/app_router.gr.dart

/// generated route for
/// [SplashPage]  ← 这是页面类
class SplashRoute extends PageRouteInfo<void> {  ← 这是路由类
  static PageInfo page = PageInfo(...);  ← 这里有 .page 属性
}

/// generated route for
/// [MyHomePage]  ← 这是页面类
class MyHomeRoute extends PageRouteInfo<MyHomeRouteArgs> {  ← 这是路由类
  static PageInfo page = PageInfo(...);  ← 这里有 .page 属性
}
```

### 方法 2: 命名规则

通常，生成的路由类名遵循以下规则：

| 页面类名 | 路由类名 |
|---------|---------|
| `XxxPage` | `XxxRoute` |
| `XxxScreen` | `XxxRoute` |
| `XxxView` | `XxxRoute` |

例如：
- `SplashPage` → `SplashRoute`
- `HomePage` → `HomeRoute`
- `DetailPage` → `DetailRoute`
- `ProfileScreen` → `ProfileRoute`

## 💡 完整示例

### 1. 创建页面（添加 @RoutePage 注解）

```dart
// lib/splash_page.dart
import 'package:auto_route/auto_route.dart';

@RoutePage()  // ← 重要：添加注解
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  
  @override
  State<SplashPage> createState() => _SplashPageState();
}
```

### 2. 在路由配置中注册（使用路由类）

```dart
// lib/router/app_router.dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,  // ← 使用路由类，不是页面类
      initial: true,
      path: '/',
    ),
  ];
}
```

### 3. 生成路由代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

这会生成 `SplashRoute` 类。

### 4. 使用路由跳转

```dart
// 使用路由类进行跳转
RouterHelper.push(SplashRoute());  // ✅ 正确
RouterHelper.push(MyHomeRoute(title: 'Home'));  // ✅ 正确
```

## 🎯 当前项目的路由映射

### 已注册的路由

| 路径 | 路由类 | 页面类 | 是否初始路由 |
|------|--------|--------|------------|
| `/` | `SplashRoute` | `SplashPage` | ✅ 是 |
| `/home` | `MyHomeRoute` | `MyHomePage` | ❌ 否 |

### 使用示例

```dart
// 跳转到闪屏页
RouterHelper.push(const SplashRoute());

// 跳转到主页（需要 title 参数）
RouterHelper.push(MyHomeRoute(title: 'Flutter Demo'));

// 替换所有页面并跳转到主页
RouterHelper.replaceAllWithContext(
  context,
  MyHomeRoute(title: 'Home'),
);
```

## ⚠️ 常见错误

### 错误 1: 使用页面类代替路由类

```dart
// ❌ 错误
AutoRoute(page: SplashPage.page)  // SplashPage 没有 .page

// ✅ 正确
AutoRoute(page: SplashRoute.page)  // SplashRoute 有 .page
```

### 错误 2: 忘记添加 @RoutePage 注解

```dart
// ❌ 错误 - 没有注解
class SplashPage extends StatefulWidget {
  ...
}

// ✅ 正确 - 添加注解
@RoutePage()
class SplashPage extends StatefulWidget {
  ...
}
```

### 错误 3: 路由类名拼写错误

```dart
// ❌ 错误
AutoRoute(page: SplashPageRoute.page)  // 应该是 SplashRoute

// ✅ 正确
AutoRoute(page: SplashRoute.page)
```

## 📚 总结

### 记住这个规则

1. **页面类**（`SplashPage`）：
   - 实际的 Widget
   - 添加 `@RoutePage()` 注解
   - 不能直接在路由配置中使用

2. **路由类**（`SplashRoute`）：
   - 由代码生成器创建
   - 在 `app_router.gr.dart` 中
   - 在路由配置中使用 `.page` 属性

### 快速检查清单

- ✅ 页面类添加了 `@RoutePage()` 注解
- ✅ 路由配置使用路由类（如 `SplashRoute.page`）
- ✅ 运行了代码生成命令
- ✅ 导入了正确的文件

现在错误已经修复，项目可以正常运行了！🎉
