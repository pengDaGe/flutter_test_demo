# Flutter AutoRoute 路由系统

本项目使用 `auto_route` 进行路由管理，并封装了 `RouterHelper` 工具类来简化路由操作。

## 🚀 快速开始

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 生成路由代码

```bash
# 一次性生成
dart run build_runner build

# 或使用 watch 模式（推荐开发时使用）
dart run build_runner watch --delete-conflicting-outputs
```

### 3. 使用路由

```dart
// 跳转到主页
RouterHelper.push(HomeRoute());

// 返回上一页
RouterHelper.pop();

// 带返回值
RouterHelper.pop(result: {'success': true});
```

## 📁 项目结构

```
lib/
├── router/
│   ├── app_router.dart          # 路由配置
│   └── app_router.gr.dart       # 自动生成的路由代码（不要手动编辑）
├── utils/
│   └── router_helper.dart       # 路由工具类
├── pages/                       # 页面目录
│   ├── splash_page.dart
│   └── ...
└── main.dart                    # 应用入口
```

## 📝 添加新页面

### 步骤 1: 创建页面文件

```dart
// lib/pages/my_page.dart
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key, required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('My Page')),
    );
  }
}
```

### 步骤 2: 在路由配置中注册

```dart
// lib/router/app_router.dart
import '../pages/my_page.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ... 现有路由
    
    // 添加新路由
    AutoRoute(
      page: MyRoute.page,
      path: '/my-page',
    ),
  ];
}

// 添加路由包装器
@RoutePage()
class MyRoute extends StatelessWidget {
  const MyRoute({super.key, required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyPage(title: title);
  }
}
```

### 步骤 3: 重新生成路由代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 步骤 4: 使用新路由

```dart
RouterHelper.push(MyRoute(title: 'Hello'));
```

## 🎯 常用场景

### 场景 1: 登录后跳转

```dart
// 登录成功后，清除所有页面并跳转到主页
void onLoginSuccess() {
  RouterHelper.replaceAll(HomeRoute());
}
```

### 场景 2: 详情页返回数据

```dart
// 在列表页
final result = await RouterHelper.push(DetailRoute(id: '123'));
if (result != null) {
  // 处理返回的数据
  print('用户选择了: $result');
}

// 在详情页
void onConfirm() {
  RouterHelper.pop(result: {'selected': true, 'data': 'some data'});
}
```

### 场景 3: 检查是否可以返回

```dart
void onBackPressed() {
  if (RouterHelper.canPop()) {
    RouterHelper.pop();
  } else {
    // 已经是根页面，显示退出提示
    showExitDialog();
  }
}
```

### 场景 4: 路由监听

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    RouterHelper.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    RouterHelper.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    print('路由变化: ${RouterHelper.currentRouteName}');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## 🔧 高级功能

### 路由参数

```dart
// 路径参数
AutoRoute(
  page: DetailRoute.page,
  path: '/detail/:id',  // :id 是路径参数
)

// 使用
@RoutePage()
class DetailRoute extends StatelessWidget {
  const DetailRoute({
    super.key,
    @PathParam('id') required this.id,  // 路径参数
    @QueryParam() this.filter,           // 查询参数
  });

  final String id;
  final String? filter;
  
  // ...
}

// 跳转
RouterHelper.push(DetailRoute(id: '123', filter: 'active'));
// 生成的 URL: /detail/123?filter=active
```

### 路由守卫

```dart
// 创建守卫
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isLoggedIn()) {
      resolver.next(true);  // 允许导航
    } else {
      router.push(LoginRoute());
      resolver.next(false);  // 阻止导航
    }
  }
}

// 应用守卫
AutoRoute(
  page: ProfileRoute.page,
  path: '/profile',
  guards: [AuthGuard()],
)
```

### 嵌套路由（Tab 导航）

```dart
AutoRoute(
  page: MainRoute.page,
  path: '/main',
  children: [
    AutoRoute(page: HomeTabRoute.page, path: 'home'),
    AutoRoute(page: DiscoverTabRoute.page, path: 'discover'),
    AutoRoute(page: ProfileTabRoute.page, path: 'profile'),
  ],
)
```

## 🐛 常见问题

### 问题 1: 生成的代码报错

**解决方案**: 删除生成的文件后重新生成

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 问题 2: 路由跳转没反应

**解决方案**: 检查是否正确初始化了 RouterHelper

```dart
// 在 main.dart 中
class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    RouterHelper.init(_appRouter);  // 确保初始化
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
```

### 问题 3: 找不到生成的路由类

**解决方案**: 确保已经运行了代码生成命令，并且导入了正确的文件

```dart
import 'router/app_router.dart';  // 导入路由配置
```

## 📚 更多文档

- [RouterHelper 详细使用指南](docs/router_helper_guide.md)
- [AutoRoute 官方文档](https://pub.dev/packages/auto_route)

## 💡 最佳实践

1. **使用 watch 模式**: 开发时使用 `dart run build_runner watch` 自动生成代码
2. **统一管理路由**: 所有路由都在 `app_router.dart` 中定义
3. **使用 RouterHelper**: 优先使用 RouterHelper 而不是直接使用 context.router
4. **命名规范**: 路由类名以 `Route` 结尾，如 `HomeRoute`、`DetailRoute`
5. **路径规范**: 使用小写和连字符，如 `/home`、`/user-profile`

## 🎉 开始使用

现在你可以开始使用这个强大的路由系统了！查看 [RouterHelper 使用指南](docs/router_helper_guide.md) 了解更多详细用法。
