# RouterHelper 使用指南

这是一个基于 `auto_route` 封装的路由管理工具类，提供了简洁易用的 API 来管理应用的路由导航。

## 📦 安装依赖

已在 `pubspec.yaml` 中配置好以下依赖：

```yaml
dependencies:
  auto_route: ^9.2.2

dev_dependencies:
  auto_route_generator: ^9.0.0
  build_runner: ^2.4.13
```

## 🔧 生成路由代码

在添加或修改路由后，需要运行以下命令生成路由代码：

```bash
dart run build_runner build
# 或者使用 watch 模式自动生成
dart run build_runner watch
```

## 📝 基本用法

### 1. 页面跳转

#### 跳转到新页面
```dart
// 方式 1: 使用全局 RouterHelper
RouterHelper.push(HomeRoute());

// 方式 2: 使用上下文
RouterHelper.pushWithContext(context, HomeRoute());

// 方式 3: 带参数跳转
RouterHelper.push(DetailRoute(id: '123'));
```

#### 替换当前页面
```dart
// 替换当前页面
RouterHelper.replace(HomeRoute());

// 清除所有页面并跳转（常用于登录后跳转）
RouterHelper.replaceAll(HomeRoute());
```

#### 推送多个页面
```dart
RouterHelper.pushAll([
  HomeRoute(),
  DetailRoute(id: '123'),
]);
```

### 2. 页面返回

#### 简单返回
```dart
// 返回上一页
RouterHelper.pop();

// 使用上下文返回
RouterHelper.popWithContext(context);
```

#### 带返回值
```dart
// 返回数据给上一页
RouterHelper.pop(result: {'success': true, 'data': 'some data'});

// 在上一页接收返回值
final result = await RouterHelper.push(DetailRoute());
if (result != null) {
  print('收到返回数据: $result');
}
```

#### 返回到指定页面
```dart
// 返回到根页面
RouterHelper.popToRoot();

// 返回到指定路由
RouterHelper.popUntilRoute('HomeRoute');

// 使用条件返回
RouterHelper.popUntil((route) => route.settings.name == 'HomeRoute');
```

### 3. 路由查询

```dart
// 检查是否可以返回
if (RouterHelper.canPop()) {
  RouterHelper.pop();
}

// 获取当前路由名称
String? routeName = RouterHelper.currentRouteName;

// 获取当前路由路径
String path = RouterHelper.currentPath;

// 获取路由栈深度
int depth = RouterHelper.stackDepth;

// 打印路由栈信息（调试用）
RouterHelper.printStack();
```

### 4. 通过路径导航

```dart
// 通过路径跳转
RouterHelper.navigateByPath('/home');

// 带参数的路径
RouterHelper.navigateByPath('/detail/123');
```

### 5. 路由监听

```dart
void _onRouteChanged() {
  print('路由发生变化: ${RouterHelper.currentRouteName}');
}

// 添加监听器
RouterHelper.addListener(_onRouteChanged);

// 移除监听器
RouterHelper.removeListener(_onRouteChanged);
```

### 6. 对话框和底部弹窗

```dart
// 显示对话框
RouterHelper.showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('提示'),
    content: Text('这是一个对话框'),
  ),
);

// 显示底部弹窗
RouterHelper.showBottomSheet(
  context: context,
  builder: (context) => Container(
    height: 200,
    child: Text('底部弹窗内容'),
  ),
);
```

## 🎯 添加新路由

### 1. 创建页面

```dart
// lib/pages/detail_page.dart
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.id,
    this.title,
  });

  final String id;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Detail')),
      body: Center(child: Text('Detail ID: $id')),
    );
  }
}
```

### 2. 在路由配置中添加

```dart
// lib/router/app_router.dart
import 'package:auto_route/auto_route.dart';
import '../pages/detail_page.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ... 其他路由
    
    // 添加新路由
    AutoRoute(
      page: DetailRoute.page,
      path: '/detail/:id',
    ),
  ];
}

// 添加路由包装器
@RoutePage()
class DetailRoute extends StatelessWidget {
  const DetailRoute({
    super.key,
    @PathParam('id') required this.id,
    @QueryParam() this.title,
  });

  final String id;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return DetailPage(id: id, title: title);
  }
}
```

### 3. 生成代码

```bash
dart run build_runner build
```

### 4. 使用新路由

```dart
// 跳转到详情页
RouterHelper.push(DetailRoute(id: '123', title: '详情页'));
```

## 🌟 高级用法

### 路由守卫

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
      guards: [AuthGuard()], // 添加路由守卫
    ),
  ];
}

// 实现路由守卫
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // 检查用户是否登录
    if (isUserLoggedIn()) {
      resolver.next(true); // 允许导航
    } else {
      // 跳转到登录页
      router.push(LoginRoute());
      resolver.next(false); // 阻止导航
    }
  }
}
```

### 嵌套路由

```dart
AutoRoute(
  page: MainRoute.page,
  path: '/main',
  children: [
    AutoRoute(page: HomeRoute.page, path: 'home'),
    AutoRoute(page: ProfileRoute.page, path: 'profile'),
    AutoRoute(page: SettingsRoute.page, path: 'settings'),
  ],
),
```

### 路由转场动画

```dart
AutoRoute(
  page: DetailRoute.page,
  path: '/detail',
  transitionsBuilder: TransitionsBuilders.slideLeft,
  durationInMilliseconds: 300,
),
```

## 📚 完整示例

```dart
// 示例：从列表页跳转到详情页，并返回结果

// 列表页
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('列表')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            onTap: () async {
              // 跳转到详情页并等待返回结果
              final result = await RouterHelper.push(
                DetailRoute(id: '$index'),
              );
              
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('返回结果: $result')),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// 详情页
class DetailPage extends StatelessWidget {
  final String id;
  
  const DetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('详情 $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 返回数据给上一页
            RouterHelper.pop(result: {'id': id, 'action': 'confirmed'});
          },
          child: Text('确认并返回'),
        ),
      ),
    );
  }
}
```

## 🐛 调试技巧

```dart
// 打印当前路由栈信息
RouterHelper.printStack();

// 输出示例:
// === 路由栈信息 ===
// 栈深度: 3
// 当前路由: DetailRoute
// 当前路径: /detail/123
// 路由栈:
//   [0] SplashRoute
//   [1] HomeRoute
//   [2] DetailRoute
// ================
```

## 📖 API 参考

### 页面跳转
- `push()` - 跳转到新页面
- `replace()` - 替换当前页面
- `replaceAll()` - 清除栈并跳转
- `pushAll()` - 推送多个页面

### 页面返回
- `pop()` - 返回上一页
- `forcePop()` - 强制返回
- `popToRoot()` - 返回到根页面
- `popUntil()` - 返回到指定页面

### 路由查询
- `canPop()` - 是否可以返回
- `currentRouteName` - 当前路由名称
- `currentPath` - 当前路由路径
- `stackDepth` - 路由栈深度

### 工具方法
- `printStack()` - 打印路由栈
- `navigateByPath()` - 通过路径导航
- `addListener()` - 添加监听器
- `removeListener()` - 移除监听器
