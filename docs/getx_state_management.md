# GetX 状态管理工具类使用文档

## 目录
- [简介](#简介)
- [安装](#安装)
- [核心概念](#核心概念)
- [工具类 API](#工具类-api)
- [使用示例](#使用示例)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

## 简介

`StateManagerHelper` 是基于 GetX 封装的状态管理工具类，提供了简洁易用的 API，帮助开发者快速实现状态管理功能。

### 主要特性

- ✅ **简单易用**: 封装了 GetX 常用功能，API 更加直观
- ✅ **类型安全**: 完整的泛型支持和类型推断
- ✅ **响应式**: 支持多种响应式数据类型
- ✅ **Worker 支持**: 提供防抖、节流等高级监听功能
- ✅ **UI 工具**: 内置 SnackBar、Dialog、Loading 等常用 UI 组件
- ✅ **生命周期管理**: 自动管理控制器的创建和销毁

## 安装

### 1. 添加依赖

在 `pubspec.yaml` 中添加 GetX 依赖：

```yaml
dependencies:
  get: ^4.6.6
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 导入工具类

```dart
import 'package:flutter_test_demo/utils/state_manager_helper.dart';
```

## 核心概念

### 1. 控制器 (Controller)

控制器是状态管理的核心，继承自 `GetxController`：

```dart
class MyController extends GetxController {
  // 响应式变量
  final count = 0.obs;
  
  // 方法
  void increment() => count.value++;
  
  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑
  }
  
  @override
  void onClose() {
    // 清理逻辑
    super.onClose();
  }
}
```

### 2. 响应式变量 (.obs)

使用 `.obs` 将普通变量转换为响应式变量：

```dart
// 基本类型
final count = 0.obs;
final name = 'John'.obs;
final isLoading = false.obs;

// 集合类型
final items = <String>[].obs;
final data = <String, int>{}.obs;
final uniqueItems = <String>{}.obs;

// 自定义类型
final user = User().obs;
```

### 3. 响应式组件

#### Obx

最简单的响应式组件，自动监听内部使用的响应式变量：

```dart
Obx(() => Text('${controller.count.value}'))
```

#### GetBuilder

需要手动调用 `update()` 的组件，性能更好：

```dart
GetBuilder<MyController>(
  builder: (controller) => Text('${controller.count.value}'),
)
```

## 工具类 API

### 控制器管理

#### putController - 注册控制器

立即创建并注册控制器实例：

```dart
final controller = StateManagerHelper.putController(MyController());

// 带标签
final controller = StateManagerHelper.putController(
  MyController(),
  tag: 'unique-tag',
);

// 永久保存
final controller = StateManagerHelper.putController(
  MyController(),
  permanent: true,
);
```

**参数说明：**
- `controller`: 控制器实例
- `tag`: 可选标签，用于区分同类型的多个实例
- `permanent`: 是否永久保存，默认为 false

#### lazyPutController - 懒加载注册

延迟创建控制器，只在首次使用时才创建：

```dart
StateManagerHelper.lazyPutController(() => MyController());

// fenix 模式：删除后可重新创建
StateManagerHelper.lazyPutController(
  () => MyController(),
  fenix: true,
);
```

**使用场景：**
- 控制器创建成本较高
- 控制器可能不会被使用
- 需要优化应用启动速度

#### findController - 查找控制器

获取已注册的控制器实例：

```dart
final controller = StateManagerHelper.findController<MyController>();

// 带标签
final controller = StateManagerHelper.findController<MyController>(
  tag: 'unique-tag',
);
```

#### isControllerRegistered - 检查注册状态

检查控制器是否已注册：

```dart
if (StateManagerHelper.isControllerRegistered<MyController>()) {
  print('控制器已注册');
}
```

#### deleteController - 删除控制器

删除已注册的控制器：

```dart
StateManagerHelper.deleteController<MyController>();

// 强制删除（即使标记为 permanent）
StateManagerHelper.deleteController<MyController>(force: true);
```

#### resetController - 重置控制器

删除并重新创建控制器：

```dart
final controller = StateManagerHelper.resetController(
  () => MyController(),
);
```

### 响应式变量创建

#### createReactive - 创建响应式变量

```dart
final count = StateManagerHelper.createReactive<int>(0);
final name = StateManagerHelper.createReactive<String>('John');
```

#### createReactiveList - 创建响应式列表

```dart
final items = StateManagerHelper.createReactiveList<String>();
final numbers = StateManagerHelper.createReactiveList<int>([1, 2, 3]);
```

#### createReactiveMap - 创建响应式 Map

```dart
final data = StateManagerHelper.createReactiveMap<String, int>();
final scores = StateManagerHelper.createReactiveMap<String, int>({'math': 90});
```

#### createReactiveSet - 创建响应式 Set

```dart
final uniqueItems = StateManagerHelper.createReactiveSet<String>();
final tags = StateManagerHelper.createReactiveSet<String>({'tag1', 'tag2'});
```

### Worker 监听器

Worker 用于监听响应式变量的变化，提供多种监听模式。

#### ever - 每次变化都触发

```dart
StateManagerHelper.worker.ever(count, (value) {
  print('Count changed to: $value');
});
```

**使用场景：**
- 日志记录
- 数据同步
- 实时更新

#### once - 只触发一次

```dart
StateManagerHelper.worker.once(count, (value) {
  print('Count first changed to: $value');
});
```

**使用场景：**
- 首次加载提示
- 一次性初始化

#### debounce - 防抖

在指定时间内没有新变化后才触发：

```dart
StateManagerHelper.worker.debounce(
  searchText,
  (value) {
    performSearch(value);
  },
  time: Duration(milliseconds: 500),
);
```

**使用场景：**
- 搜索输入
- 表单验证
- API 请求优化

#### interval - 节流

在指定时间间隔内只触发一次：

```dart
StateManagerHelper.worker.interval(
  scrollPosition,
  (value) {
    updateUI(value);
  },
  time: Duration(seconds: 1),
);
```

**使用场景：**
- 滚动事件
- 窗口调整
- 高频事件处理

### UI 工具方法

#### showSnackBar - 显示提示

```dart
StateManagerHelper.showSnackBar(
  '成功',
  '操作完成',
  duration: Duration(seconds: 3),
);
```

#### showLoading - 显示加载

```dart
StateManagerHelper.showLoading('加载中...');

// 执行操作
await someAsyncOperation();

StateManagerHelper.hideLoading();
```

#### showConfirmDialog - 确认对话框

```dart
StateManagerHelper.showConfirmDialog(
  '确认删除',
  '确定要删除这条记录吗？',
  onConfirm: () {
    deleteRecord();
  },
  onCancel: () {
    print('取消删除');
  },
  confirmText: '删除',
  cancelText: '取消',
);
```

### 其他工具方法

#### batchUpdate - 批量更新

减少 UI 重建次数：

```dart
StateManagerHelper.batchUpdate(() {
  controller.name.value = 'New Name';
  controller.age.value = 25;
  controller.email.value = 'new@email.com';
});
```

#### updateWidgets - 刷新指定组件

```dart
StateManagerHelper.updateWidgets(['counter', 'title']);
```

#### delayed - 延迟执行

```dart
StateManagerHelper.delayed(
  Duration(seconds: 2),
  () => print('2秒后执行'),
);
```

## 使用示例

### 基础示例：计数器

#### 1. 创建控制器

```dart
class CounterController extends GetxController {
  final count = 0.obs;
  
  void increment() => count.value++;
  void decrement() => count.value--;
}
```

#### 2. 在页面中使用

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 注册控制器
    final controller = StateManagerHelper.putController(CounterController());
    
    return Scaffold(
      appBar: AppBar(title: Text('计数器')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 响应式显示
            Obx(() => Text(
              '${controller.count.value}',
              style: TextStyle(fontSize: 48),
            )),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.decrement,
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.increment,
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 进阶示例：用户管理

#### 1. 定义数据模型

```dart
class User {
  String name;
  int age;
  String email;
  
  User({
    required this.name,
    required this.age,
    required this.email,
  });
}
```

#### 2. 创建控制器

```dart
class UserController extends GetxController {
  // 响应式用户对象
  final user = User(name: '', age: 0, email: '').obs;
  
  // 响应式列表
  final users = <User>[].obs;
  
  // 加载状态
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUsers();
    
    // 监听用户变化
    StateManagerHelper.worker.ever(user, (u) {
      print('User updated: ${u.name}');
    });
  }
  
  // 加载用户列表
  Future<void> loadUsers() async {
    isLoading.value = true;
    StateManagerHelper.showLoading('加载中...');
    
    try {
      // 模拟 API 调用
      await Future.delayed(Duration(seconds: 2));
      
      users.value = [
        User(name: 'Alice', age: 25, email: 'alice@example.com'),
        User(name: 'Bob', age: 30, email: 'bob@example.com'),
      ];
      
      StateManagerHelper.showSnackBar('成功', '加载完成');
    } catch (e) {
      StateManagerHelper.showSnackBar('错误', '加载失败: $e');
    } finally {
      isLoading.value = false;
      StateManagerHelper.hideLoading();
    }
  }
  
  // 添加用户
  void addUser(User newUser) {
    users.add(newUser);
    StateManagerHelper.showSnackBar('成功', '用户已添加');
  }
  
  // 删除用户
  void deleteUser(int index) {
    StateManagerHelper.showConfirmDialog(
      '确认删除',
      '确定要删除 ${users[index].name} 吗？',
      onConfirm: () {
        users.removeAt(index);
        StateManagerHelper.showSnackBar('成功', '用户已删除');
      },
    );
  }
  
  // 更新用户
  void updateUser(User updatedUser) {
    user.value = updatedUser;
  }
}
```

#### 3. 创建页面

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = StateManagerHelper.putController(UserController());
    
    return Scaffold(
      appBar: AppBar(title: Text('用户管理')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('${user.age}岁 - ${user.email}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => controller.deleteUser(index),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加用户逻辑
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 搜索防抖示例

```dart
class SearchController extends GetxController {
  final searchText = ''.obs;
  final results = <String>[].obs;
  final isSearching = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // 防抖搜索：500ms 内无新输入才执行搜索
    StateManagerHelper.worker.debounce(
      searchText,
      (text) {
        if (text.isNotEmpty) {
          performSearch(text);
        } else {
          results.clear();
        }
      },
      time: Duration(milliseconds: 500),
    );
  }
  
  Future<void> performSearch(String query) async {
    isSearching.value = true;
    
    try {
      // 模拟 API 搜索
      await Future.delayed(Duration(seconds: 1));
      results.value = ['Result 1', 'Result 2', 'Result 3'];
    } finally {
      isSearching.value = false;
    }
  }
}
```

## 最佳实践

### 1. 控制器命名规范

```dart
// ✅ 推荐
class UserController extends GetxController {}
class HomeController extends GetxController {}

// ❌ 不推荐
class UserCtrl extends GetxController {}
class user_controller extends GetxController {}
```

### 2. 合理使用响应式

```dart
class MyController extends GetxController {
  // ✅ 需要响应式的变量
  final count = 0.obs;
  final userName = ''.obs;
  
  // ✅ 不需要响应式的常量
  final int maxCount = 100;
  final String appName = 'MyApp';
}
```

### 3. 生命周期管理

```dart
class MyController extends GetxController {
  late Worker _countWorker;
  
  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑
    _countWorker = StateManagerHelper.worker.ever(count, _handleCountChange);
  }
  
  @override
  void onReady() {
    super.onReady();
    // 页面准备就绪后的逻辑
    loadData();
  }
  
  @override
  void onClose() {
    // 清理资源
    _countWorker.dispose();
    super.onClose();
  }
  
  void _handleCountChange(int value) {
    print('Count: $value');
  }
  
  Future<void> loadData() async {
    // 加载数据
  }
}
```

### 4. 错误处理

```dart
Future<void> loadData() async {
  try {
    isLoading.value = true;
    final data = await api.fetchData();
    items.value = data;
  } catch (e) {
    StateManagerHelper.showSnackBar('错误', '加载失败: $e');
  } finally {
    isLoading.value = false;
  }
}
```

### 5. 使用 GetBuilder 优化性能

对于不需要频繁更新的组件，使用 `GetBuilder` 代替 `Obx`：

```dart
// 频繁更新 - 使用 Obx
Obx(() => Text('${controller.count.value}'))

// 不频繁更新 - 使用 GetBuilder
GetBuilder<MyController>(
  id: 'user-info',
  builder: (controller) => Text(controller.userName.value),
)

// 手动触发更新
controller.update(['user-info']);
```

### 6. 避免内存泄漏

```dart
// ✅ 使用完后删除控制器
StateManagerHelper.deleteController<MyController>();

// ✅ 或者使用 fenix 模式的懒加载
StateManagerHelper.lazyPutController(
  () => MyController(),
  fenix: true,
);
```

### 7. 合理使用 Worker

```dart
class MyController extends GetxController {
  final searchText = ''.obs;
  late Worker _searchWorker;
  
  @override
  void onInit() {
    super.onInit();
    
    // ✅ 保存 Worker 引用以便后续清理
    _searchWorker = StateManagerHelper.worker.debounce(
      searchText,
      performSearch,
      time: Duration(milliseconds: 500),
    );
  }
  
  @override
  void onClose() {
    // ✅ 清理 Worker
    _searchWorker.dispose();
    super.onClose();
  }
}
```

## 常见问题

### Q1: Obx 报错 "The getter 'value' isn't defined"

**原因：** 变量没有使用 `.obs` 声明为响应式。

**解决：**
```dart
// ❌ 错误
final count = 0;

// ✅ 正确
final count = 0.obs;
```

### Q2: 控制器找不到

**原因：** 控制器未注册或已被删除。

**解决：**
```dart
// 先检查是否注册
if (!StateManagerHelper.isControllerRegistered<MyController>()) {
  StateManagerHelper.putController(MyController());
}

final controller = StateManagerHelper.findController<MyController>();
```

### Q3: 页面销毁后控制器仍存在

**原因：** 控制器被标记为 `permanent: true`。

**解决：**
```dart
// 不需要永久保存时，不要设置 permanent
StateManagerHelper.putController(MyController()); // permanent 默认为 false

// 或者手动删除
StateManagerHelper.deleteController<MyController>(force: true);
```

### Q4: Worker 没有触发

**原因：** 可能是监听的变量没有真正改变。

**解决：**
```dart
// ❌ 引用没变，不会触发
final user = User().obs;
user.value.name = 'New Name'; // 不会触发

// ✅ 创建新对象，会触发
user.value = User(name: 'New Name');

// ✅ 或者使用 refresh()
user.value.name = 'New Name';
user.refresh();
```

### Q5: 如何在控制器之间通信

**方法1: 直接获取其他控制器**
```dart
class ControllerA extends GetxController {
  void doSomething() {
    final controllerB = StateManagerHelper.findController<ControllerB>();
    controllerB.someMethod();
  }
}
```

**方法2: 使用 GetX 的事件总线**
```dart
// 发送事件
Get.find<EventBus>().fire(MyEvent());

// 监听事件
eventBus.on<MyEvent>().listen((event) {
  // 处理事件
});
```

### Q6: 如何测试使用 GetX 的代码

```dart
void main() {
  setUp(() {
    // 在测试前注册控制器
    StateManagerHelper.putController(MyController());
  });
  
  tearDown(() {
    // 测试后清理
    StateManagerHelper.deleteController<MyController>(force: true);
  });
  
  test('Counter increment test', () {
    final controller = StateManagerHelper.findController<MyController>();
    controller.increment();
    expect(controller.count.value, 1);
  });
}
```

## 总结

`StateManagerHelper` 提供了一套完整的状态管理解决方案：

- 🎯 **简单**: API 设计直观，易于上手
- 🚀 **高效**: 基于 GetX，性能优异
- 🛠️ **实用**: 内置常用 UI 工具方法
- 📦 **完整**: 涵盖状态管理的各个方面

建议从简单的计数器示例开始，逐步掌握各种高级功能。

## 参考资源

- [GetX 官方文档](https://github.com/jonataslaw/getx)
- [Flutter 官方文档](https://flutter.dev)
- 示例代码：`lib/examples/counter_page.dart`
