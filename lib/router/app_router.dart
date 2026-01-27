import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../splash_page.dart';
import '../main.dart';

part 'app_router.gr.dart';

/// 应用路由配置
/// 
/// 使用 AutoRoute 进行路由管理
/// 运行 `dart run build_runner build` 生成路由代码
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 闪屏页 - 初始路由
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
  ];
}
