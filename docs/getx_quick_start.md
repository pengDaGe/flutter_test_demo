# GetX 状态管理 - 快速开始

## 📦 安装

### 1. 添加依赖

已在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  get: ^4.6.6
```

### 2. 安装依赖包

```bash
flutter pub get
```

## 🚀 快速上手

### 5 分钟入门示例

#### 步骤 1: 创建控制器

```dart
import 'package:get/get.dart';

class CounterController extends GetxController {
  // 响应式变量
  final count = 0.obs;
  
  // 方法
  void increment() => count.value++;
}
```

#### 步骤 2: 使用工具类注册控制器

```dart
import 'package:flutter_test_demo/utils/state_manager_helper.dart';

// 在页面中注册
final controller = StateManagerHelper.putController(CounterController());
```

#### 步骤 3: 在 UI 中使用

```dart
// 响应式显示
Obx(() => Text('${controller.count.value}'))

// 调用方法
ElevatedButton(
  onPressed: controller.increment,
  child: Text('增加'),
)
```

## 📁 项目文件结构

```
lib/
├── utils/
│   └── state_manager_helper.dart    # 状态管理工具类
├── examples/
│   ├── counter_controller.dart      # 计数器控制器示例
│   └── counter_page.dart            # 计数器页面示例
docs/
└── getx_state_management.md         # 完整使用文档
```

## 🎯 核心功能

### 1. 控制器管理

```dart
// 注册控制器
StateManagerHelper.putController(MyController());

// 懒加载
StateManagerHelper.lazyPutController(() => MyController());

// 查找控制器
final controller = StateManagerHelper.findController<MyController>();

// 删除控制器
StateManagerHelper.deleteController<MyController>();
```

### 2. 响应式变量

```dart
// 基本类型
final count = 0.obs;
final name = 'John'.obs;

// 集合类型
final items = <String>[].obs;
final data = <String, int>{}.obs;

// 修改值
count.value = 10;
items.add('new item');
```

### 3. Worker 监听

```dart
// 每次变化都触发
StateManagerHelper.worker.ever(count, (value) {
  print('Count: $value');
});

// 防抖（搜索场景）
StateManagerHelper.worker.debounce(
  searchText,
  (value) => performSearch(value),
  time: Duration(milliseconds: 500),
);
```

### 4. UI 工具

```dart
// 提示消息
StateManagerHelper.showSnackBar('成功', '操作完成');

// 加载对话框
StateManagerHelper.showLoading('加载中...');
StateManagerHelper.hideLoading();

// 确认对话框
StateManagerHelper.showConfirmDialog(
  '提示',
  '确定要删除吗？',
  onConfirm: () => deleteItem(),
);
```

## 📝 运行示例

### 方法 1: 直接运行示例页面

在 `main.dart` 中导入并使用：

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
    return GetMaterialApp(  // 使用 GetMaterialApp 替代 MaterialApp
      title: 'GetX Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CounterPage(),  // 使用示例页面
    );
  }
}
```

### 方法 2: 添加到现有路由

如果项目使用了 `auto_route`，可以添加到路由配置中：

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CounterRoute.page, path: '/counter'),
    // ... 其他路由
  ];
}
```

## 🎨 完整示例

查看 `lib/examples/counter_page.dart` 获取完整的示例代码，包括：

- ✅ 基本计数器功能
- ✅ 用户输入处理
- ✅ 历史记录管理
- ✅ 异步操作示例
- ✅ 批量更新示例
- ✅ Worker 使用示例

## 📚 学习路径

1. **入门** (5分钟)
   - 阅读本快速开始指南
   - 运行计数器示例

2. **基础** (30分钟)
   - 学习控制器创建和注册
   - 掌握响应式变量使用
   - 了解 Obx 组件

3. **进阶** (1小时)
   - Worker 监听器使用
   - 生命周期管理
   - 性能优化技巧

4. **高级** (2小时)
   - 复杂状态管理
   - 多控制器协作
   - 最佳实践应用

## 🔗 相关资源

- **完整文档**: `docs/getx_state_management.md`
- **示例代码**: `lib/examples/`
- **工具类源码**: `lib/utils/state_manager_helper.dart`

## ❓ 常见问题

### Q: 如何在现有项目中使用？

A: 只需三步：
1. 导入工具类
2. 创建控制器
3. 使用 `StateManagerHelper.putController()` 注册

### Q: 与其他状态管理方案的区别？

A: GetX 的优势：
- 更少的样板代码
- 更好的性能
- 内置路由和依赖注入
- 学习曲线平缓

### Q: 需要修改现有代码吗？

A: 不需要大改：
- 可以与现有状态管理方案共存
- 逐步迁移即可
- 新功能优先使用 GetX

## 💡 提示

- 🎯 从简单示例开始学习
- 📖 遇到问题查看完整文档
- 🔍 参考示例代码
- 🚀 在实际项目中实践

## 下一步

- [ ] 运行 `flutter pub get` 安装依赖
- [ ] 查看 `lib/examples/counter_page.dart` 示例
- [ ] 阅读完整文档 `docs/getx_state_management.md`
- [ ] 在项目中创建第一个控制器

---

**开始使用 GetX，让状态管理变得简单！** 🎉
