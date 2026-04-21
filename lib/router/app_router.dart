import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../splash_page.dart';
import '../main.dart';
import '../examples/counter_page.dart';
import '../examples/language_settings_page.dart';
import '../login_page.dart';
import '../video_generating_page.dart';
import '../vibeo_main_page.dart';
import '../create_video_page.dart';
import '../video_result_page.dart';
import '../effects_discover_page.dart';
import '../discover_main_page.dart';
import '../podcast_page.dart';

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
    
    // 登录页面
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    
    // Vibeo 主界面
    AutoRoute(
      page: VibeoMainRoute.page,
      path: '/vibeo-main',
    ),
    
    // 创建视频页面
    AutoRoute(
      page: CreateVideoRoute.page,
      path: '/create-video',
    ),
    
    // 视频生成中页面
    AutoRoute(
      page: VideoGeneratingRoute.page,
      path: '/video-generating',
    ),
    
    // 视频结果页面
    AutoRoute(
      page: VideoResultRoute.page,
      path: '/video-result',
    ),
    
    // 发现主页面（包含 Video 和 Image 标签）
    AutoRoute(
      page: DiscoverMainRoute.page,
      path: '/discover-main',
    ),
    
    // 发现列表页面
    AutoRoute(
      page: EffectsDiscoverRoute.page,
      path: '/effects-discover',
    ),
    
    // 播客详情页面
    AutoRoute(
      page: PodcastRoute.page,
      path: '/podcast',
    ),
  ];
}
