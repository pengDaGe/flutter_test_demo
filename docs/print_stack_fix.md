# ✅ printStack 方法错误已修复

## 🐛 问题说明

### 错误代码
```dart
static void printStack() {
  debugPrint('=== 路由栈信息 ===');
  debugPrint('栈深度: $stackDepth');
  debugPrint('当前路由: $currentRouteName');
  debugPrint('当前路径: $currentPath');
  debugPrint('路由栈:');
  for (var i = 0; i < stack.length; i++) {
    debugPrint('  [$i] ${stack[i].routeName}');  // ❌ 错误：routeName 属性不存在
  }
  debugPrint('================');
}
```

### 错误原因

`RouteMatch` 对象没有 `routeName` 属性，正确的属性名是 `name`。

## ✅ 修复方案

### 正确代码
```dart
static void printStack() {
  debugPrint('=== 路由栈信息 ===');
  debugPrint('栈深度: $stackDepth');
  debugPrint('当前路由: $currentRouteName');
  debugPrint('当前路径: $currentPath');
  debugPrint('路由栈:');
  for (var i = 0; i < stack.length; i++) {
    debugPrint('  [$i] ${stack[i].name}');  // ✅ 正确：使用 name 属性
  }
  debugPrint('================');
}
```

## 📋 RouteMatch 常用属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `name` | `String` | 路由名称 |
| `path` | `String` | 路由路径 |
| `stringMatch` | `String` | 匹配的字符串 |
| `segments` | `List<PathSegment>` | 路径段列表 |
| `queryParams` | `Parameters` | 查询参数 |
| `pathParams` | `Parameters` | 路径参数 |

## 💡 使用示例

### 示例 1: 打印路由栈（调试用）

```dart
// 在任意地方调用
RouterHelper.printStack();

// 输出示例:
// === 路由栈信息 ===
// 栈深度: 3
// 当前路由: DetailRoute
// 当前路径: /detail/123
// 路由栈:
//   [0] SplashRoute
//   [1] MyHomeRoute
//   [2] DetailRoute
// ================
```

### 示例 2: 在页面中使用

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调试页面'),
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              // 点击按钮打印路由栈
              RouterHelper.printStack();
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            RouterHelper.printStack();
          },
          child: Text('打印路由栈'),
        ),
      ),
    );
  }
}
```

### 示例 3: 在路由监听器中使用

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    RouterHelper.init(_appRouter);
    
    // 添加路由监听器
    RouterHelper.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    // 每次路由变化时打印路由栈
    print('路由发生变化');
    RouterHelper.printStack();
  }

  @override
  void dispose() {
    RouterHelper.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
```

### 示例 4: 获取路由栈信息

```dart
// 获取路由栈
List<RouteMatch> routeStack = RouterHelper.stack;

// 遍历路由栈
for (var route in routeStack) {
  print('路由名称: ${route.name}');
  print('路由路径: ${route.path}');
}

// 获取栈深度
int depth = RouterHelper.stackDepth;
print('当前路由栈深度: $depth');

// 获取当前路由信息
String? currentName = RouterHelper.currentRouteName;
String currentPath = RouterHelper.currentPath;
print('当前路由: $currentName');
print('当前路径: $currentPath');
```

## 🎯 实际应用场景

### 场景 1: 调试路由问题

```dart
void debugRouteIssue() {
  print('开始调试路由问题...');
  RouterHelper.printStack();
  
  // 检查是否可以返回
  if (RouterHelper.canPop()) {
    print('可以返回上一页');
  } else {
    print('已经是根页面，无法返回');
  }
}
```

### 场景 2: 监控路由变化

```dart
class RouteMonitor {
  static void startMonitoring() {
    RouterHelper.addListener(_onRouteChanged);
  }

  static void stopMonitoring() {
    RouterHelper.removeListener(_onRouteChanged);
  }

  static void _onRouteChanged() {
    print('=== 路由变化监控 ===');
    print('时间: ${DateTime.now()}');
    RouterHelper.printStack();
  }
}
```

### 场景 3: 验证路由状态

```dart
void validateRouteState() {
  // 打印当前路由栈
  RouterHelper.printStack();
  
  // 验证路由栈深度
  if (RouterHelper.stackDepth > 5) {
    print('警告: 路由栈过深，可能存在内存泄漏');
  }
  
  // 验证当前路由
  if (RouterHelper.currentRouteName == 'ErrorRoute') {
    print('错误: 当前在错误页面');
  }
}
```

## 📊 输出格式说明

```
=== 路由栈信息 ===
栈深度: 3                    ← 路由栈中的页面数量
当前路由: DetailRoute        ← 当前显示的路由名称
当前路径: /detail/123        ← 当前路由的完整路径
路由栈:                      ← 路由栈列表（从底部到顶部）
  [0] SplashRoute           ← 栈底（最早的页面）
  [1] MyHomeRoute           ← 中间页面
  [2] DetailRoute           ← 栈顶（当前页面）
================
```

## ⚠️ 注意事项

### 1. 仅用于调试

```dart
// ✅ 推荐 - 在开发环境使用
if (kDebugMode) {
  RouterHelper.printStack();
}

// ⚠️ 不推荐 - 在生产环境使用
RouterHelper.printStack();  // 会输出调试信息
```

### 2. 性能考虑

```dart
// ✅ 推荐 - 按需调用
void onButtonPressed() {
  RouterHelper.printStack();
}

// ❌ 不推荐 - 频繁调用
@override
Widget build(BuildContext context) {
  RouterHelper.printStack();  // 每次重建都会打印
  return Container();
}
```

### 3. 路由栈顺序

路由栈是从底部到顶部排列的：
- `[0]` - 栈底（最早的页面，通常是初始页面）
- `[1]` - 中间页面
- `[n]` - 栈顶（当前显示的页面）

## 🔗 相关方法

### 获取路由信息

```dart
// 获取当前路由名称
String? name = RouterHelper.currentRouteName;

// 获取当前路由路径
String path = RouterHelper.currentPath;

// 获取路由栈
List<RouteMatch> stack = RouterHelper.stack;

// 获取栈深度
int depth = RouterHelper.stackDepth;

// 检查是否可以返回
bool canPop = RouterHelper.canPop();
```

### 路由操作

```dart
// 返回上一页
RouterHelper.pop();

// 返回到根页面
await RouterHelper.popToRoot();

// 清除栈并跳转
RouterHelper.replaceAll(MyHomeRoute(title: 'Home'));
```

## 📚 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'utils/router_helper.dart';

@RoutePage()
class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('路由调试工具'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 打印路由栈
          ElevatedButton(
            onPressed: () {
              RouterHelper.printStack();
            },
            child: Text('打印路由栈'),
          ),
          
          SizedBox(height: 16),
          
          // 显示路由信息
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('当前路由: ${RouterHelper.currentRouteName}'),
                  Text('当前路径: ${RouterHelper.currentPath}'),
                  Text('栈深度: ${RouterHelper.stackDepth}'),
                  Text('可以返回: ${RouterHelper.canPop()}'),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // 路由栈列表
          Text('路由栈:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...RouterHelper.stack.asMap().entries.map((entry) {
            return ListTile(
              leading: Text('[${entry.key}]'),
              title: Text(entry.value.name),
              subtitle: Text(entry.value.path),
            );
          }).toList(),
        ],
      ),
    );
  }
}
```

## ✨ 总结

- ✅ 使用 `stack[i].name` 获取路由名称
- ✅ 使用 `stack[i].path` 获取路由路径
- ✅ `printStack()` 方法用于调试路由问题
- ✅ 仅在开发环境使用，避免在生产环境输出调试信息

错误已修复，现在可以正常使用 `RouterHelper.printStack()` 方法了！🎉
