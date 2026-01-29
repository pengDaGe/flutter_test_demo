# 日志工具类 (Log Utility) 使用指南

本文档介绍了 `flutter_test_demo` 项目中封装的日志工具类 `Log` 的使用方法。该工具类基于 `logging` 包进行封装，旨在提供统一、规范且具备环境感知能力的日志输出功能。

## 1. 核心特性

- **环境自动感应**：自动识别 `Debug` 和 `Release` 环境。
  - **Debug 环境**：开启所有级别的日志输出，并利用 `dart:developer` 提供结构化展示（包含时间、级别、Logger 名称、错误堆栈等）。
  - **Release 环境**：自动屏蔽日志打印，确保应用性能和信息安全。
- **丰富的日志级别**：提供从 `Finest` 到 `Shout` 的多种级别，满足不同场景的需求。
- **IDE 友好**：使用 `developer.log` 代替 `print`，在主流 IDE（VS Code, Android Studio）中支持更好的过滤和日志着色。

## 2. 初始化

日志工具类需要在应用启动时（`main` 函数中）进行初始化。项目已默认在 `lib/main.dart` 中完成此配置：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化日志工具类
  Log.init(); 
  
  // ... 其他初始化
  runApp(MyApp());
}
```

## 3. 基础用法

可以通过 `Log` 类直接调用静态方法进行日志打印：

### 打印不同级别的日志

```dart
import 'package:flutter_test_demo/utils/logger.dart';

// 1. 详细日志 (Verbose/Finest) - 用于极细颗粒度的逻辑追踪
Log.v("This is a verbose message");

// 2. 调试日志 (Debug/Fine) - 用于常规开发阶段的调试
Log.d("API request started: /api/v1/user");

// 3. 信息日志 (Info) - 用于记录关键里程碑或状态变化
Log.i("Language changed to: English");

// 4. 警告日志 (Warning) - 用于记录非致命的潜在问题
Log.w("Network connection is slow, retrying...");

// 5. 错误日志 (Error/Severe) - 用于记录异常及配套的堆栈信息
Log.e("Failed to parse configurations");

// 6. 极严日志 (Shout) - 用于必须要醒目展示的信息
Log.shouting("CRITICAL: Application state corrupted!");
```

## 4. 进阶用法：打印异常与堆栈

在处理 `try-catch` 时，建议将错误对象和堆栈传递给 `Log.e`，以便在调试时快速定位问题：

```dart
try {
  // 模拟可能出错的代码
  var result = someFunction();
} catch (e, stackTrace) {
  // 打印错误描述、错误对象以及堆栈轨迹
  Log.e("An error occurred during task execution", e, stackTrace);
}
```

## 5. 日志级别对应关系

封装类 `Log` 与 `logging` 包及常用的日志级别对应如下：

| Log 方法 | logging 等级 | 推荐场景 |
| :--- | :--- | :--- |
| `Log.v()` | `Level.FINEST` | 极细粒度的执行路径追踪 |
| `Log.d()` | `Level.FINE` | 常规开发调试信息 |
| `Log.i()` | `Level.INFO` | 用户行为、配置变更、生命周期节点 |
| `Log.w()` | `Level.WARNING` | 异常边缘、性能预警 |
| `Log.e()` | `Level.SEVERE` | 捕获的异常、崩溃前兆 |
| `Log.shouting()` | `Level.SHOUT` | 极其严重的错误或强制显示的日志 |

## 6. 注意事项

- **禁止直接使用 `print`**：在项目中请统一使用 `Log` 工具类，避免滥用 `print` 生成无法受控的日志流。
- **Release 环境屏蔽**：`Log` 工具类在初始化时已设置 `Logger.root.level = Level.OFF`（非 Debug 模式下），因此在打包发布后不会有日志输出到控制台。
