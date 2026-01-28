# 主题管理系统使用指南

## 简介

本项目采用基于 **GetX** 的主题管理方案，支持：
- ✅ **亮色模式 (Light Mode)**
- ✅ **暗色模式 (Dark Mode)**
- ✅ **系统跟随 (System Mode)**
- ✅ **持久化存储**：自动记录用户的主题偏好
- ✅ **即时响应**：切换主题时全局 UI 自动重建，无需重启应用

## 核心组件

### 1. ThemeHelper (`lib/theme/theme_helper.dart`)
顶层工具类类，提供简洁的 API 供外部调用。采用单例模式，内部封装了 `ThemeController`。

### 2. AppThemes (`lib/theme/app_themes.dart`)
定义具体的样式。基于 **Material 3** 规范，配置了颜色、按钮样式、AppBar 样式和卡片样式等。

### 3. ThemeController (`lib/theme/theme_controller.dart`)
GetX 控制器，处理具体的状态逻辑和本地存储 (`SharedPreferences`)。

---

## 快速集成

### 1. 初始化
在 `main.dart` 的 `main` 函数中调用：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 语言初始化
  await LanguageHelper.init();
  
  // ✅ 主题初始化
  ThemeHelper.init(); 
  
  runApp(MyApp());
}
```

### 2. 全局配置
在 `MyApp` 中通过 `Obx` 监听变化：

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MaterialApp.router(
        // ... 其他配置
        
        // ✅ 应用主题配置
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeHelper.themeMode, // 获取当前生效的模式
        
        routerConfig: _appRouter.config(),
      );
    });
  }
}
```

---

## 使用方法 (API)

### 切换主题模式
提供了三种模式的选择：

```dart
// 设置为亮色模式
await ThemeHelper.setThemeMode(AppThemeMode.light);

// 设置为暗色模式
await ThemeHelper.setThemeMode(AppThemeMode.dark);

// 设置为跟随系统
await ThemeHelper.setThemeMode(AppThemeMode.system);
```

### 一键切换 (Toggle)
在亮色和暗色之间快速互换（常用于简单的开关按钮）：

```dart
await ThemeHelper.toggleTheme();
```

### 检查当前状态

```dart
bool isDark = ThemeHelper.isDarkMode;
AppThemeMode currentMode = ThemeHelper.currentMode;
```

---

## UI 实现示例

### 主题切换开关 (Switch)

```dart
Obx(() => Switch(
  value: ThemeHelper.isDarkMode,
  onChanged: (value) => ThemeHelper.toggleTheme(),
))
```

### 模式选择器 (SegmentedButton/Radio)

```dart
Obx(() => SegmentedButton<AppThemeMode>(
  segments: const [
    ButtonSegment(value: AppThemeMode.light, icon: Icon(Icons.light_mode)),
    ButtonSegment(value: AppThemeMode.dark, icon: Icon(Icons.dark_mode)),
    ButtonSegment(value: AppThemeMode.system, icon: Icon(Icons.brightness_auto)),
  ],
  selected: {ThemeHelper.currentMode},
  onSelectionChanged: (modes) => ThemeHelper.setThemeMode(modes.first),
))
```

---

## 自定义主题

如果需要修改颜色或添加新的组件样式，请前往 `lib/theme/app_themes.dart`：

*   **修改配色**：调整 `ColorScheme.fromSeed`。
*   **组件自定义**：在 `ThemeData` 下添加对应的 `ThemeData`（如 `tabBarTheme`, `inputDecorationTheme` 等）。

## 注意事项

1. **类型安全**：始终通过 `ThemeHelper` 操作，不要直接修改 `ThemeController` 的内部变量。
2. **响应式约束**：在使用颜色而不依赖系统的组件中，如果需要随主题变化，必须使用 `Obx` 包裹或使用 `Theme.of(context)`。
3. **Flutter SDK 版本**：本系统已适配最新的 Flutter (3.32.0+) 类型要求，请确保使用 `CardThemeData` 而不是 `CardTheme`。
