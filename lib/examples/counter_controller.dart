import 'package:get/get.dart';
import '../utils/state_manager_helper.dart';

/// 计数器控制器
/// 演示 GetX 状态管理的基本用法
class CounterController extends GetxController {
  // 响应式变量 - 计数器值
  final count = 0.obs;
  
  // 响应式变量 - 用户名
  final userName = 'Guest'.obs;
  
  // 响应式列表 - 历史记录
  final history = <String>[].obs;
  
  // 普通变量（不需要响应式）
  int maxCount = 100;

  @override
  void onInit() {
    super.onInit();
    print('CounterController 初始化');
    
    // 监听 count 变化
    StateManagerHelper.worker.ever(count, (value) {
      print('Count changed to: $value');
      // 添加到历史记录
      history.add('Count: $value at ${DateTime.now().toString().substring(11, 19)}');
    });
    
    // 防抖示例：用户名输入
    StateManagerHelper.worker.debounce(
      userName,
      (value) {
        print('Username debounced: $value');
      },
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onReady() {
    super.onReady();
    print('CounterController 准备就绪');
  }

  @override
  void onClose() {
    print('CounterController 销毁');
    super.onClose();
  }

  /// 增加计数
  void increment() {
    if (count.value < maxCount) {
      count.value++;
    } else {
      StateManagerHelper.showSnackBar(
        '提示',
        '已达到最大值 $maxCount',
      );
    }
  }

  /// 减少计数
  void decrement() {
    if (count.value > 0) {
      count.value--;
    } else {
      StateManagerHelper.showSnackBar(
        '提示',
        '已达到最小值 0',
      );
    }
  }

  /// 重置计数
  void reset() {
    StateManagerHelper.showConfirmDialog(
      '确认重置',
      '确定要重置计数器吗？',
      onConfirm: () {
        count.value = 0;
        history.clear();
        StateManagerHelper.showSnackBar('成功', '计数器已重置');
      },
    );
  }

  /// 批量更新示例
  void batchUpdate() {
    StateManagerHelper.batchUpdate(() {
      count.value = 50;
      userName.value = 'Admin';
    });
  }

  /// 模拟异步操作
  Future<void> asyncIncrement() async {
    StateManagerHelper.showLoading('处理中...');
    
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 2));
    
    increment();
    
    StateManagerHelper.hideLoading();
    StateManagerHelper.showSnackBar('成功', '异步操作完成');
  }

  /// 清空历史记录
  void clearHistory() {
    history.clear();
  }
}
