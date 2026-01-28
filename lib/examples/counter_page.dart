import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_route/auto_route.dart';
import '../utils/state_manager_helper.dart';
import 'counter_controller.dart';

/// 计数器页面
/// 演示如何使用 StateManagerHelper 和 GetX 控制器
@RoutePage()
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 方式1: 使用 StateManagerHelper 注册控制器
    final controller = StateManagerHelper.putController(CounterController());
    
    // 方式2: 直接使用 Get.put (等同于上面)
    // final controller = Get.put(CounterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX 状态管理示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reset,
            tooltip: '重置',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 计数器显示区域
            _buildCounterCard(controller),
            
            const SizedBox(height: 16),
            
            // 用户名输入区域
            _buildUserNameCard(controller),
            
            const SizedBox(height: 16),
            
            // 操作按钮区域
            _buildActionButtons(controller),
            
            const SizedBox(height: 16),
            
            // 历史记录区域
            _buildHistoryCard(controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: '增加',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 计数器卡片
  Widget _buildCounterCard(CounterController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '当前计数',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Obx: 响应式组件，当 count 变化时自动重建
            Obx(() => Text(
                  '${controller.count.value}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )),
            const SizedBox(height: 8),
            Obx(() => LinearProgressIndicator(
                  value: controller.count.value / controller.maxCount,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  '${controller.count.value} / ${controller.maxCount}',
                  style: TextStyle(color: Colors.grey[600]),
                )),
          ],
        ),
      ),
    );
  }

  /// 用户名卡片
  Widget _buildUserNameCard(CounterController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '用户信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                controller.userName.value = value;
              },
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  '当前用户: ${controller.userName.value}',
                  style: TextStyle(color: Colors.grey[600]),
                )),
          ],
        ),
      ),
    );
  }

  /// 操作按钮
  Widget _buildActionButtons(CounterController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '操作',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.increment,
                  icon: const Icon(Icons.add),
                  label: const Text('增加'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('减少'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重置'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.batchUpdate,
                  icon: const Icon(Icons.update),
                  label: const Text('批量更新'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.asyncIncrement,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('异步操作'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 历史记录卡片
  Widget _buildHistoryCard(CounterController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '历史记录',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: controller.clearHistory,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.history.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      '暂无历史记录',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.history.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = controller.history[controller.history.length - 1 - index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${controller.history.length - index}'),
                    ),
                    title: Text(item),
                    dense: true,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 使用懒加载的示例页面
class LazyCounterPage extends StatelessWidget {
  const LazyCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用懒加载方式注册控制器
    StateManagerHelper.lazyPutController(() => CounterController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('懒加载示例'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 只有在这里才会真正创建控制器实例
            final controller = StateManagerHelper.findController<CounterController>();
            controller.increment();
          },
          child: const Text('点击创建并使用控制器'),
        ),
      ),
    );
  }
}

/// GetBuilder 使用示例
/// 适用于不需要响应式的场景，性能更好
class GetBuilderExample extends StatelessWidget {
  const GetBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StateManagerHelper.putController(CounterController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetBuilder 示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GetBuilder: 需要手动调用 update() 来刷新
            GetBuilder<CounterController>(
              builder: (controller) {
                return Text(
                  '${controller.count.value}',
                  style: const TextStyle(fontSize: 48),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.increment();
                // 需要手动调用 update() 来刷新 UI
                controller.update();
              },
              child: const Text('增加'),
            ),
          ],
        ),
      ),
    );
  }
}
