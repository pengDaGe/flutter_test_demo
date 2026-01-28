import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../splash_page.dart';
import '../main.dart';
import '../examples/counter_page.dart';
import '../examples/language_settings_page.dart';

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
    
    // GetX 计数器示例页面
    AutoRoute(
      page: CounterRoute.page,
      path: '/counter',
    ),
    
    // 语言设置页面
    AutoRoute(
      page: LanguageSettingsRoute.page,
      path: '/language-settings',
    ),
  ];
}
