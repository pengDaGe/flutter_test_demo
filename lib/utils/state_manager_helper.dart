import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';

/// GetX 状态管理工具类
/// 提供常用的状态管理方法和最佳实践
class StateManagerHelper {
  StateManagerHelper._();

  /// 注册单例控制器
  /// [controller] - 控制器实例
  /// [tag] - 可选的标签，用于区分同一类型的多个实例
  /// [permanent] - 是否永久保存，默认为 false
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.putController(MyController());
  /// ```
  static T putController<T extends GetxController>(
    T controller, {
    String? tag,
    bool permanent = false,
  }) {
    return Get.put<T>(
      controller,
      tag: tag,
      permanent: permanent,
    );
  }

  /// 懒加载注册控制器
  /// [builder] - 控制器构建函数
  /// [tag] - 可选的标签
  /// [fenix] - 是否在控制器被删除后可以重新创建，默认为 false
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.lazyPutController(() => MyController());
  /// ```
  static void lazyPutController<T extends GetxController>(
    T Function() builder, {
    String? tag,
    bool fenix = false,
  }) {
    Get.lazyPut<T>(
      builder,
      tag: tag,
      fenix: fenix,
    );
  }

  /// 获取已注册的控制器
  /// [tag] - 可选的标签
  /// 
  /// 示例:
  /// ```dart
  /// final controller = StateManagerHelper.findController<MyController>();
  /// ```
  static T findController<T extends GetxController>({String? tag}) {
    return Get.find<T>(tag: tag);
  }

  /// 检查控制器是否已注册
  /// [tag] - 可选的标签
  /// 
  /// 返回: true 表示已注册，false 表示未注册
  static bool isControllerRegistered<T extends GetxController>({String? tag}) {
    return Get.isRegistered<T>(tag: tag);
  }

  /// 删除已注册的控制器
  /// [tag] - 可选的标签
  /// [force] - 是否强制删除，即使控制器被标记为永久
  /// 
  /// 返回: true 表示删除成功，false 表示删除失败
  static Future<bool> deleteController<T extends GetxController>({
    String? tag,
    bool force = false,
  }) {
    return Get.delete<T>(tag: tag, force: force);
  }

  /// 重置控制器（删除后重新创建）
  /// [builder] - 控制器构建函数
  /// [tag] - 可选的标签
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.resetController(() => MyController());
  /// ```
  static T resetController<T extends GetxController>(
    T Function() builder, {
    String? tag,
  }) {
    if (isControllerRegistered<T>(tag: tag)) {
      deleteController<T>(tag: tag, force: true);
    }
    return putController(builder(), tag: tag);
  }

  /// 创建响应式变量
  /// [value] - 初始值
  /// 
  /// 示例:
  /// ```dart
  /// final count = StateManagerHelper.createReactive<int>(0);
  /// ```
  static Rx<T> createReactive<T>(T value) {
    return Rx<T>(value);
  }

  /// 创建响应式列表
  /// [value] - 初始列表，默认为空列表
  /// 
  /// 示例:
  /// ```dart
  /// final items = StateManagerHelper.createReactiveList<String>(['item1']);
  /// ```
  static RxList<T> createReactiveList<T>([List<T>? value]) {
    return RxList<T>(value ?? []);
  }

  /// 创建响应式 Map
  /// [value] - 初始 Map，默认为空 Map
  /// 
  /// 示例:
  /// ```dart
  /// final data = StateManagerHelper.createReactiveMap<String, int>({'key': 1});
  /// ```
  static RxMap<K, V> createReactiveMap<K, V>([Map<K, V>? value]) {
    return RxMap<K, V>(value ?? {});
  }

  /// 创建响应式 Set
  /// [value] - 初始 Set，默认为空 Set
  /// 
  /// 示例:
  /// ```dart
  /// final uniqueItems = StateManagerHelper.createReactiveSet<String>({'item1'});
  /// ```
  static RxSet<T> createReactiveSet<T>([Set<T>? value]) {
    return RxSet<T>(value ?? {});
  }

  /// 批量更新（减少重建次数）
  /// [callback] - 更新回调函数
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.batchUpdate(() {
  ///   controller.name.value = 'New Name';
  ///   controller.age.value = 25;
  /// });
  /// ```
  static void batchUpdate(VoidCallback callback) {
    // 使用 WidgetsBinding 在下一帧执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  /// 显示 SnackBar
  /// [title] - 标题
  /// [message] - 消息内容
  /// [duration] - 显示时长，默认 3 秒
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.showSnackBar('成功', '操作完成');
  /// ```
  static void showSnackBar(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      duration: duration,
    );
  }

  /// 显示加载对话框
  /// [message] - 加载提示文字
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.showLoading('加载中...');
  /// ```
  static void showLoading([String? message]) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// 关闭加载对话框
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.hideLoading();
  /// ```
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// 显示确认对话框
  /// [title] - 标题
  /// [message] - 消息内容
  /// [onConfirm] - 确认回调
  /// [onCancel] - 取消回调
  /// [confirmText] - 确认按钮文字，默认为 "确定"
  /// [cancelText] - 取消按钮文字，默认为 "取消"
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.showConfirmDialog(
  ///   '提示',
  ///   '确定要删除吗？',
  ///   onConfirm: () => print('已确认'),
  /// );
  /// ```
  static void showConfirmDialog(
    String title,
    String message, {
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = '确定',
    String cancelText = '取消',
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: confirmText,
      textCancel: cancelText,
      onConfirm: () {
        Get.back();
        onConfirm?.call();
      },
      onCancel: onCancel,
    );
  }

  /// 获取当前路由名称
  static String? get currentRoute => Get.currentRoute;

  /// 获取前一个路由名称
  static String? get previousRoute => Get.previousRoute;

  /// 检查是否有 Snackbar 正在显示
  static bool get isSnackbarOpen => Get.isSnackbarOpen;

  /// 检查是否有 Dialog 正在显示
  static bool get isDialogOpen => Get.isDialogOpen ?? false;

  /// 检查是否有 BottomSheet 正在显示
  static bool get isBottomSheetOpen => Get.isBottomSheetOpen ?? false;

  /// 刷新指定 ID 的组件
  /// 注意：此方法应该在控制器内部调用
  /// 
  /// 示例:
  /// ```dart
  /// // 在控制器中使用
  /// class MyController extends GetxController {
  ///   void updateUI() {
  ///     update(['counter', 'title']);
  ///   }
  /// }
  /// ```
  @Deprecated('请在控制器中直接调用 update() 方法')
  static void updateWidgets(List<Object> ids) {
    // 此方法已废弃，请在控制器中直接使用 update() 方法
    // 例如: controller.update(['id1', 'id2']);
  }

  /// 延迟执行
  /// [duration] - 延迟时长
  /// [callback] - 回调函数
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.delayed(
  ///   Duration(seconds: 2),
  ///   () => print('2秒后执行'),
  /// );
  /// ```
  static void delayed(Duration duration, VoidCallback callback) {
    Future.delayed(duration, callback);
  }

  /// Worker 工具方法集合
  static WorkerHelper get worker => WorkerHelper._();
}

/// Worker 工具类
/// 用于监听响应式变量的变化
class WorkerHelper {
  WorkerHelper._();

  /// 每次值改变时都会触发
  /// [listener] - 响应式变量
  /// [callback] - 回调函数
  /// 
  /// 示例:
  /// ```dart
  /// StateManagerHelper.worker.ever(count, (value) => print('count: $value'));
  /// ```
  Worker ever<T>(RxInterface<T> listener, void Function(T) callback) {
    return _createEverWorker<T>(listener, callback);
  }

  /// 只在值第一次改变时触发
  /// [listener] - 响应式变量
  /// [callback] - 回调函数
  Worker once<T>(RxInterface<T> listener, void Function(T) callback) {
    return _createOnceWorker<T>(listener, callback);
  }

  /// 在一段时间内没有变化后触发（防抖）
  /// [listener] - 响应式变量
  /// [callback] - 回调函数
  /// [time] - 防抖时间，默认 800 毫秒
  Worker debounce<T>(
    RxInterface<T> listener,
    void Function(T) callback, {
    Duration time = const Duration(milliseconds: 800),
  }) {
    return _createDebounceWorker<T>(listener, callback, time: time);
  }

  /// 在指定时间间隔内只触发一次（节流）
  /// [listener] - 响应式变量
  /// [callback] - 回调函数
  /// [time] - 节流时间，默认 1 秒
  Worker interval<T>(
    RxInterface<T> listener,
    void Function(T) callback, {
    Duration time = const Duration(seconds: 1),
  }) {
    return _createIntervalWorker<T>(listener, callback, time: time);
  }
}

// 内部辅助函数，调用 GetX 的全局 Worker 函数
Worker _createEverWorker<T>(RxInterface<T> listener, void Function(T) callback) {
  return ever<T>(listener, callback);
}

Worker _createOnceWorker<T>(RxInterface<T> listener, void Function(T) callback) {
  return once<T>(listener, callback);
}

Worker _createDebounceWorker<T>(
  RxInterface<T> listener,
  void Function(T) callback, {
  Duration? time,
}) {
  return debounce<T>(listener, callback, time: time);
}

Worker _createIntervalWorker<T>(
  RxInterface<T> listener,
  void Function(T) callback, {
  Duration? time,
}) {
  return interval<T>(listener, callback, time: time!);
}
