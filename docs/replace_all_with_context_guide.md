# RouterHelper.replaceAllWithContext 使用指南

## 📝 方法签名

```dart
static Future<void> replaceAllWithContext(
  BuildContext context,
  PageRouteInfo route,
)
```

## 🎯 功能说明

`replaceAllWithContext` 方法用于**清除整个路由栈并跳转到新页面**。这个方法常用于：

- 登录后跳转到主页（清除登录页）
- 闪屏页跳转到主页（清除闪屏页）
- 退出登录返回到登录页（清除所有页面）
- 重置应用状态到初始页面

## 📋 参数说明

| 参数 | 类型 | 说明 |
|------|------|------|
| `context` | `BuildContext` | 当前页面的上下文 |
| `route` | `PageRouteInfo` | 要跳转的目标路由 |

## 💡 使用示例

### 示例 1: 闪屏页跳转到主页（当前使用）

```dart
// lib/splash_page.dart
class _SplashPageState extends State<SplashPage> {
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      // 清除闪屏页，跳转到主页
      RouterHelper.replaceAllWithContext(
        context,
        MyHomeRoute(title: 'Flutter Demo Home Page'),
      );
    }
  }
}
```

**效果**: 
- ❌ 清除闪屏页（用户无法返回）
- ✅ 显示主页
- 📚 路由栈: `[MyHomePage]`

### 示例 2: 登录成功后跳转

```dart
class LoginPage extends StatelessWidget {
  void _onLoginSuccess(BuildContext context) {
    // 登录成功，清除登录页面，跳转到主页
    RouterHelper.replaceAllWithContext(
      context,
      MyHomeRoute(title: 'Welcome'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _onLoginSuccess(context),
          child: Text('登录'),
        ),
      ),
    );
  }
}
```

**效果**:
- ❌ 清除所有之前的页面（包括登录页）
- ✅ 显示主页
- 🔙 用户无法返回到登录页

### 示例 3: 退出登录

```dart
class ProfilePage extends StatelessWidget {
  void _logout(BuildContext context) {
    // 退出登录，清除所有页面，返回登录页
    RouterHelper.replaceAllWithContext(
      context,
      LoginRoute(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: Text('退出登录'),
        ),
      ),
    );
  }
}
```

**效果**:
- ❌ 清除所有页面（主页、个人中心等）
- ✅ 显示登录页
- 📚 路由栈: `[LoginPage]`

### 示例 4: 重置应用状态

```dart
class ErrorPage extends StatelessWidget {
  void _resetApp(BuildContext context) {
    // 发生错误，重置应用到初始状态
    RouterHelper.replaceAllWithContext(
      context,
      SplashRoute(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('发生错误'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetApp(context),
              child: Text('重新开始'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔄 与其他方法的对比

### 1. `replaceAllWithContext` vs `push`

```dart
// push - 添加新页面到栈顶（可以返回）
RouterHelper.push(MyHomeRoute(title: 'Home'));
// 路由栈: [SplashPage, MyHomePage] ✅ 可以返回

// replaceAllWithContext - 清除所有页面（无法返回）
RouterHelper.replaceAllWithContext(context, MyHomeRoute(title: 'Home'));
// 路由栈: [MyHomePage] ❌ 无法返回
```

### 2. `replaceAllWithContext` vs `replace`

```dart
// replace - 替换当前页面（保留之前的页面）
RouterHelper.replace(MyHomeRoute(title: 'Home'));
// 路由栈: [PageA, MyHomePage] ✅ 可以返回到 PageA

// replaceAllWithContext - 清除所有页面
RouterHelper.replaceAllWithContext(context, MyHomeRoute(title: 'Home'));
// 路由栈: [MyHomePage] ❌ 无法返回
```

### 3. `replaceAllWithContext` vs `popToRoot`

```dart
// popToRoot - 返回到根页面（保留根页面）
await RouterHelper.popToRoot();
// 路由栈: [RootPage] ✅ 保留原来的根页面

// replaceAllWithContext - 替换为新的根页面
RouterHelper.replaceAllWithContext(context, MyHomeRoute(title: 'Home'));
// 路由栈: [MyHomePage] ✅ 新的根页面
```

## 📊 使用场景总结

| 场景 | 使用方法 | 路由栈变化 |
|------|----------|-----------|
| 闪屏页 → 主页 | `replaceAllWithContext` | `[Splash]` → `[Home]` |
| 登录 → 主页 | `replaceAllWithContext` | `[Login]` → `[Home]` |
| 退出登录 | `replaceAllWithContext` | `[Home, Profile]` → `[Login]` |
| 重置应用 | `replaceAllWithContext` | `[Any Pages]` → `[Splash]` |
| 普通跳转 | `push` | `[A]` → `[A, B]` |
| 替换当前页 | `replace` | `[A, B]` → `[A, C]` |

## ⚠️ 注意事项

### 1. 需要 BuildContext

```dart
// ✅ 正确 - 在 Widget 中使用
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RouterHelper.replaceAllWithContext(
      context,  // 使用 build 方法的 context
      MyHomeRoute(title: 'Home'),
    );
  }
}

// ❌ 错误 - 没有 context
void someFunction() {
  RouterHelper.replaceAllWithContext(
    ???,  // 没有 context
    MyHomeRoute(title: 'Home'),
  );
}
```

### 2. 检查 mounted 状态

```dart
// ✅ 推荐 - 在异步操作后检查
Future<void> _navigateToHome() async {
  await Future.delayed(Duration(seconds: 2));
  
  if (mounted) {  // 检查 Widget 是否还在
    RouterHelper.replaceAllWithContext(
      context,
      MyHomeRoute(title: 'Home'),
    );
  }
}

// ⚠️ 不推荐 - 可能导致错误
Future<void> _navigateToHome() async {
  await Future.delayed(Duration(seconds: 2));
  // 如果 Widget 已经被销毁，这里会报错
  RouterHelper.replaceAllWithContext(
    context,
    MyHomeRoute(title: 'Home'),
  );
}
```

### 3. 无法返回

```dart
// 使用 replaceAllWithContext 后，用户无法通过返回按钮回到之前的页面
RouterHelper.replaceAllWithContext(context, MyHomeRoute(title: 'Home'));

// 如果需要保留返回功能，使用 push
RouterHelper.push(MyHomeRoute(title: 'Home'));
```

## 🎯 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'router/app_router.dart';
import 'utils/router_helper.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  /// 导航到主页
  Future<void> _navigateToHome() async {
    // 等待 2.5 秒
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // 检查 Widget 是否还在
    if (mounted) {
      // 清除闪屏页，跳转到主页
      RouterHelper.replaceAllWithContext(
        context,
        MyHomeRoute(title: 'Flutter Demo Home Page'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

## 📚 相关方法

- `push()` - 跳转到新页面（可返回）
- `replace()` - 替换当前页面
- `replaceAll()` - 清除所有页面（不需要 context）
- `popToRoot()` - 返回到根页面
- `pop()` - 返回上一页

## 🔗 更多信息

查看 `docs/router_helper_guide.md` 了解更多 RouterHelper 的使用方法。
