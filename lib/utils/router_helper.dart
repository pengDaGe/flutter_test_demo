import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// 路由导航工具类
/// 
/// 封装了常用的路由操作，简化页面跳转和导航
class RouterHelper {
  RouterHelper._();

  /// 获取当前路由器
  static StackRouter get router => _currentRouter;
  static late StackRouter _currentRouter;

  /// 初始化路由器（在 MaterialApp 中设置）
  static void init(StackRouter router) {
    _currentRouter = router;
  }

  /// 获取当前上下文的路由器
  static StackRouter of(BuildContext context) {
    return context.router;
  }

  // ==================== 页面跳转 ====================

  /// 跳转到指定页面
  /// 
  /// [route] 要跳转的路由
  /// 
  /// 示例:
  /// ```dart
  /// RouterHelper.push(HomeRoute());
  /// ```
  static Future<T?> push<T extends Object?>(PageRouteInfo route) {
    return router.push<T>(route);
  }

  /// 跳转到指定页面（使用上下文）
  static Future<T?> pushWithContext<T extends Object?>(
    BuildContext context,
    PageRouteInfo route,
  ) {
    return context.router.push<T>(route);
  }

  /// 替换当前页面
  /// 
  /// [route] 要跳转的路由
  /// 
  /// 示例:
  /// ```dart
  /// RouterHelper.replace(HomeRoute());
  /// ```
  static Future<T?> replace<T extends Object?>(PageRouteInfo route) {
    return router.replace<T>(route);
  }

  /// 替换当前页面（使用上下文）
  static Future<T?> replaceWithContext<T extends Object?>(
    BuildContext context,
    PageRouteInfo route,
  ) {
    return context.router.replace<T>(route);
  }

  /// 清除所有路由栈并跳转到新页面
  /// 
  /// [route] 要跳转的路由
  /// 
  /// 示例:
  /// ```dart
  /// RouterHelper.replaceAll(HomeRoute());
  /// ```
  static Future<void> replaceAll(PageRouteInfo route) {
    return router.replaceAll([route]);
  }

  /// 清除所有路由栈并跳转到新页面（使用上下文）
  static Future<void> replaceAllWithContext(
    BuildContext context,
    PageRouteInfo route,
  ) {
    return context.router.replaceAll([route]);
  }

  /// 推送多个页面
  /// 
  /// [routes] 要推送的路由列表
  static Future<void> pushAll(List<PageRouteInfo> routes) {
    return router.pushAll(routes);
  }

  // ==================== 页面返回 ====================

  /// 返回上一页
  /// 
  /// [result] 返回给上一页的数据
  /// 
  /// 示例:
  /// ```dart
  /// RouterHelper.pop(); // 简单返回
  /// RouterHelper.pop(result: {'success': true}); // 带返回值
  /// ```
  static void pop<T extends Object?>({T? result}) {
    router.maybePop<T>(result);
  }

  /// 返回上一页（使用上下文）
  static void popWithContext<T extends Object?>(
    BuildContext context, {
    T? result,
  }) {
    context.router.maybePop<T>(result);
  }

  /// 强制返回上一页（不检查是否可以返回）
  static void forcePop<T extends Object?>({T? result}) {
    if (result != null) {
      router.maybePop<T>(result);
    } else {
      router.maybePop();
    }
  }

  /// 返回到根页面
  static Future<void> popToRoot() async {
    return router.popUntilRoot();
  }

  /// 返回到指定路由
  /// 
  /// [predicate] 判断条件
  static void popUntil(RoutePredicate predicate) {
    router.popUntil(predicate);
  }

  /// 返回到指定路由（通过路由名称）
  /// 
  /// [routeName] 路由名称
  static void popUntilRoute(String routeName) {
    router.popUntilRouteWithName(routeName);
  }

  // ==================== 路由查询 ====================

  /// 检查是否可以返回
  static bool canPop() {
    return router.canPop();
  }

  /// 检查是否可以返回（使用上下文）
  static bool canPopWithContext(BuildContext context) {
    return context.router.canPop();
  }

  /// 获取当前路由名称
  static String? get currentRouteName {
    return router.current.name;
  }

  /// 获取当前路由路径
  static String get currentPath {
    return router.current.path;
  }

  /// 获取路由栈
  static List<RouteMatch> get stack {
    return router.stackData.map((e) => e.route).toList();
  }

  /// 获取路由栈深度
  static int get stackDepth {
    return router.stackData.length;
  }

  // ==================== 导航到命名路由 ====================

  /// 通过路径导航
  /// 
  /// [path] 路由路径
  /// [includePrefixMatches] 是否包含前缀匹配
  /// 
  /// 示例:
  /// ```dart
  /// RouterHelper.navigateByPath('/home');
  /// ```
  static Future<void> navigateByPath(
    String path, {
    bool includePrefixMatches = false,
  }) {
    return router.navigateNamed(
      path,
      includePrefixMatches: includePrefixMatches,
    );
  }

  /// 通过路径导航（使用上下文）
  static Future<void> navigateByPathWithContext(
    BuildContext context,
    String path, {
    bool includePrefixMatches = false,
  }) {
    return context.router.navigateNamed(
      path,
      includePrefixMatches: includePrefixMatches,
    );
  }

  // ==================== 路由监听 ====================

  /// 添加路由监听器
  /// 
  /// [listener] 监听器回调
  static void addListener(void Function() listener) {
    router.addListener(listener);
  }

  /// 移除路由监听器
  /// 
  /// [listener] 监听器回调
  static void removeListener(void Function() listener) {
    router.removeListener(listener);
  }

  // ==================== 对话框和底部弹窗 ====================

  /// 显示对话框
  /// 
  /// [builder] 对话框构建器
  /// [barrierDismissible] 点击外部是否关闭
  static Future<T?> showDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showAdaptiveDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }

  /// 显示底部弹窗
  /// 
  /// [builder] 底部弹窗构建器
  /// [isScrollControlled] 是否可滚动控制
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isScrollControlled: isScrollControlled,
    );
  }

  // ==================== 工具方法 ====================

  /// 打印当前路由栈信息（调试用）
  static void printStack() {
    debugPrint('=== 路由栈信息 ===');
    debugPrint('栈深度: $stackDepth');
    debugPrint('当前路由: $currentRouteName');
    debugPrint('当前路径: $currentPath');
    debugPrint('路由栈:');
    for (var i = 0; i < stack.length; i++) {
      debugPrint('  [$i] ${stack[i].name}');
    }
    debugPrint('================');
  }

  /// 清除路由栈（保留根路由）
  static Future<void> clearStackExceptRoot() async {
    return router.popUntilRoot();
  }
}
