# GetX 状态管理工具类

基于 GetX 封装的 Flutter 状态管理工具类，提供简洁易用的 API 和完整的功能支持。

## ✨ 特性

- 🎯 **简单易用** - 封装常用功能，API 更直观
- 🚀 **高性能** - 基于 GetX，响应式更新高效
- 📦 **功能完整** - 涵盖状态管理、UI 工具、Worker 监听等
- 🛠️ **类型安全** - 完整的泛型支持和类型推断
- 📚 **文档齐全** - 详细的使用文档和示例代码
- 🎨 **最佳实践** - 内置最佳实践和性能优化建议

## 📦 安装

### 1. 依赖已添加

在 `pubspec.yaml` 中已添加：

```yaml
dependencies:
  get: ^4.6.6
```

### 2. 安装依赖

```bash
flutter pub get
```

## 🚀 快速开始

### 创建控制器

```dart
import 'package:get/get.dart';

class CounterController extends GetxController {
  final count = 0.obs;
  
  void increment() => count.value++;
}
```

### 注册和使用

```dart
import 'package:flutter_test_demo/utils/state_manager_helper.dart';

// 注册控制器
final controller = StateManagerHelper.putController(CounterController());

// 在 UI 中使用
Obx(() => Text('${controller.count.value}'))
```

## 📁 文件结构

```
lib/
├── utils/
│   └── state_manager_helper.dart    # 核心工具类
└── examples/
    ├── counter_controller.dart      # 控制器示例
    └── counter_page.dart            # 页面示例

docs/
├── getx_quick_start.md              # 快速开始指南
└── getx_state_management.md         # 完整使用文档
```

## 🎯 核心功能

### 1. 控制器管理

```dart
// 注册控制器
StateManagerHelper.putController(MyController());

// 懒加载注册
StateManagerHelper.lazyPutController(() => MyController());

// 查找控制器
final controller = StateManagerHelper.findController<MyController>();

// 检查是否注册
bool isRegistered = StateManagerHelper.isControllerRegistered<MyController>();

// 删除控制器
StateManagerHelper.deleteController<MyController>();

// 重置控制器
StateManagerHelper.resetController(() => MyController());
```

### 2. 响应式变量

```dart
// 创建响应式变量
final count = StateManagerHelper.createReactive<int>(0);
final items = StateManagerHelper.createReactiveList<String>();
final data = StateManagerHelper.createReactiveMap<String, int>();
final uniqueItems = StateManagerHelper.createReactiveSet<String>();

// 使用 .obs 创建
final name = 'John'.obs;
final age = 25.obs;
```

### 3. Worker 监听器

```dart
// 每次变化都触发
StateManagerHelper.worker.ever(count, (value) {
  print('Count: $value');
});

// 只触发一次
StateManagerHelper.worker.once(count, (value) {
  print('First change: $value');
});

// 防抖（适用于搜索）
StateManagerHelper.worker.debounce(
  searchText,
  (value) => performSearch(value),
  time: Duration(milliseconds: 500),
);

// 节流（适用于滚动）
StateManagerHelper.worker.interval(
  scrollPosition,
  (value) => updateUI(value),
  time: Duration(seconds: 1),
);
```

### 4. UI 工具方法

```dart
// 显示提示
StateManagerHelper.showSnackBar('成功', '操作完成');

// 显示加载
StateManagerHelper.showLoading('加载中...');
StateManagerHelper.hideLoading();

// 确认对话框
StateManagerHelper.showConfirmDialog(
  '确认删除',
  '确定要删除吗？',
  onConfirm: () => deleteItem(),
  onCancel: () => print('取消'),
);
```

### 5. 其他工具

```dart
// 批量更新
StateManagerHelper.batchUpdate(() {
  controller.name.value = 'New Name';
  controller.age.value = 25;
});

// 延迟执行
StateManagerHelper.delayed(
  Duration(seconds: 2),
  () => print('2秒后执行'),
);

// 刷新指定组件
StateManagerHelper.updateWidgets(['counter', 'title']);
```

## 📝 使用示例

### 基础计数器

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = StateManagerHelper.putController(CounterController());
    
    return Scaffold(
      appBar: AppBar(title: Text('计数器')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              '${controller.count.value}',
              style: TextStyle(fontSize: 48),
            )),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text('增加'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 搜索防抖

```dart
class SearchController extends GetxController {
  final searchText = ''.obs;
  final results = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // 500ms 防抖
    StateManagerHelper.worker.debounce(
      searchText,
      (text) {
        if (text.isNotEmpty) {
          performSearch(text);
        }
      },
      time: Duration(milliseconds: 500),
    );
  }
  
  Future<void> performSearch(String query) async {
    // 执行搜索
  }
}
```

### 异步操作

```dart
Future<void> loadData() async {
  StateManagerHelper.showLoading('加载中...');
  
  try {
    final data = await api.fetchData();
    items.value = data;
    StateManagerHelper.showSnackBar('成功', '加载完成');
  } catch (e) {
    StateManagerHelper.showSnackBar('错误', '加载失败: $e');
  } finally {
    StateManagerHelper.hideLoading();
  }
}
```

## 📚 文档

- **[快速开始指南](docs/getx_quick_start.md)** - 5分钟快速上手
- **[完整使用文档](docs/getx_state_management.md)** - 详细的 API 说明和最佳实践
- **[示例代码](lib/examples/)** - 完整的示例项目

## 🎨 示例项目

运行示例：

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'examples/counter_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      home: CounterPage(),
    );
  }
}
```

查看 `lib/examples/counter_page.dart` 获取完整示例，包括：

- ✅ 基本计数器功能
- ✅ 用户输入处理
- ✅ 历史记录管理
- ✅ 异步操作
- ✅ 批量更新
- ✅ Worker 使用

## 🔧 API 概览

### 控制器管理
- `putController()` - 注册控制器
- `lazyPutController()` - 懒加载注册
- `findController()` - 查找控制器
- `isControllerRegistered()` - 检查注册状态
- `deleteController()` - 删除控制器
- `resetController()` - 重置控制器

### 响应式变量
- `createReactive()` - 创建响应式变量
- `createReactiveList()` - 创建响应式列表
- `createReactiveMap()` - 创建响应式 Map
- `createReactiveSet()` - 创建响应式 Set

### Worker 监听
- `worker.ever()` - 每次变化触发
- `worker.once()` - 只触发一次
- `worker.debounce()` - 防抖
- `worker.interval()` - 节流

### UI 工具
- `showSnackBar()` - 显示提示
- `showLoading()` - 显示加载
- `hideLoading()` - 隐藏加载
- `showConfirmDialog()` - 确认对话框

### 其他工具
- `batchUpdate()` - 批量更新
- `updateWidgets()` - 刷新组件
- `delayed()` - 延迟执行

## 💡 最佳实践

### 1. 合理使用响应式

```dart
class MyController extends GetxController {
  // ✅ 需要响应式
  final count = 0.obs;
  
  // ✅ 不需要响应式
  final int maxCount = 100;
}
```

### 2. 生命周期管理

```dart
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // 初始化
  }
  
  @override
  void onClose() {
    // 清理资源
    super.onClose();
  }
}
```

### 3. 错误处理

```dart
try {
  await loadData();
} catch (e) {
  StateManagerHelper.showSnackBar('错误', '操作失败: $e');
}
```

### 4. 性能优化

```dart
// 使用 GetBuilder 代替 Obx（不频繁更新时）
GetBuilder<MyController>(
  builder: (controller) => Text(controller.userName.value),
)
```

## ❓ 常见问题

### Q: 如何在现有项目中使用？

只需导入工具类并注册控制器即可，无需修改现有代码。

### Q: 与 Provider/Bloc 的区别？

GetX 更简洁，样板代码更少，性能更好，学习曲线更平缓。

### Q: 如何调试？

在控制器的 `onInit()` 中添加日志，或使用 Worker 监听变化。

## 🔗 相关资源

- [GetX 官方文档](https://github.com/jonataslaw/getx)
- [Flutter 官方文档](https://flutter.dev)
- [GetX 中文文档](https://github.com/jonataslaw/getx/blob/master/README.zh-cn.md)

## 📄 许可证

本项目仅供学习和参考使用。

---

**开始使用 GetX，让状态管理变得简单！** 🎉
