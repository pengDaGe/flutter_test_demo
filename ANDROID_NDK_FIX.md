# Android NDK 问题解决方案

## 问题描述

遇到 NDK 相关错误：

```
[CXX1101] NDK at /Users/peng/Library/Android/sdk/ndk/27.0.12077973 
did not have a source.properties file
```

## 原因分析

1. **NDK 未正确安装**: 指定的 NDK 27.0.12077973 没有正确安装或已损坏
2. **版本不匹配**: shared_preferences_android 要求特定 NDK 版本，但本地没有

## 解决方案

### 方案 1: 移除 NDK 版本限制（推荐）✅

**已应用此方案**

修改 `android/app/build.gradle.kts`：

```kotlin
android {
    namespace = "com.example.flutter_test_demo"
    compileSdk = flutter.compileSdkVersion
    // 注释掉 ndkVersion，让系统自动选择
    // ndkVersion = flutter.ndkVersion
}
```

**优点**:
- ✅ 不需要手动安装特定 NDK 版本
- ✅ 让 Flutter 和 Gradle 自动处理 NDK 版本
- ✅ 避免版本冲突

**验证**:
```bash
cd /Users/peng/flutter_test_demo
flutter clean
flutter pub get
flutter run
```

### 方案 2: 安装正确的 NDK 版本

如果方案 1 不行，可以手动安装 NDK：

#### 使用 Android Studio

1. 打开 Android Studio
2. Tools → SDK Manager
3. 切换到 "SDK Tools" 标签
4. 勾选 "Show Package Details"
5. 展开 "NDK (Side by side)"
6. 勾选版本 27.0.12077973
7. 点击 "Apply" 安装

#### 使用命令行

```bash
# 使用 sdkmanager 安装
sdkmanager "ndk;27.0.12077973"

# 或者安装最新版本
sdkmanager "ndk-bundle"
```

### 方案 3: 使用已安装的 NDK 版本

检查已安装的 NDK 版本：

```bash
ls /Users/peng/Library/Android/sdk/ndk/
```

如果有其他版本（如 26.x），可以在 `build.gradle.kts` 中指定：

```kotlin
ndkVersion = "26.3.11579264"  // 使用已安装的版本
```

### 方案 4: 完全清理并重建

```bash
cd /Users/peng/flutter_test_demo

# 清理 Flutter 缓存
flutter clean

# 清理 Gradle 缓存
cd android
./gradlew clean
rm -rf .gradle
rm -rf build
rm -rf app/build

# 返回项目根目录
cd ..

# 重新获取依赖
flutter pub get

# 运行应用
flutter run
```

## 当前配置

**文件**: `android/app/build.gradle.kts`

```kotlin
android {
    namespace = "com.example.flutter_test_demo"
    compileSdk = flutter.compileSdkVersion
    // 使用 Flutter 默认的 NDK 版本，避免版本不匹配问题
    // ndkVersion = flutter.ndkVersion
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    // ... 其他配置
}
```

## 为什么注释掉 ndkVersion

1. **自动管理**: 不指定 ndkVersion 时，Gradle 会自动选择合适的版本
2. **避免冲突**: 避免与插件要求的版本冲突
3. **简化配置**: 减少手动管理 NDK 版本的复杂度
4. **兼容性**: 让系统自动处理版本兼容性

## shared_preferences 的 NDK 要求

虽然 `shared_preferences_android` 建议使用 NDK 27，但实际上：

- ✅ 大多数情况下不需要明确指定 NDK 版本
- ✅ Gradle 会自动下载和使用合适的 NDK
- ✅ 注释掉 ndkVersion 通常可以解决版本冲突

## 验证步骤

### 1. 清理项目

```bash
flutter clean
```

### 2. 重新获取依赖

```bash
flutter pub get
```

### 3. 运行应用

```bash
flutter run
```

### 4. 检查构建日志

如果仍有问题，查看详细日志：

```bash
flutter run -v
```

## 常见问题

### Q1: 仍然报 NDK 错误？

A: 尝试完全清理：
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

### Q2: 需要特定 NDK 版本？

A: 检查已安装的版本：
```bash
ls ~/Library/Android/sdk/ndk/
```

使用已安装的版本：
```kotlin
ndkVersion = "26.3.11579264"  // 替换为实际版本
```

### Q3: 如何安装 NDK？

A: 最简单的方法是通过 Android Studio 的 SDK Manager 安装。

### Q4: shared_preferences 能正常工作吗？

A: 可以。不指定 ndkVersion 不会影响 shared_preferences 的功能。

## 推荐配置

对于大多数项目，推荐配置：

```kotlin
android {
    namespace = "com.example.flutter_test_demo"
    compileSdk = flutter.compileSdkVersion
    // 不指定 ndkVersion，让系统自动管理
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    defaultConfig {
        applicationId = "com.example.flutter_test_demo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

## 总结

- ✅ 已注释掉 `ndkVersion` 配置
- ✅ 让 Gradle 自动管理 NDK 版本
- ✅ 避免手动安装特定 NDK 版本
- ✅ 简化配置，提高兼容性

**问题应该已解决！运行 `flutter clean && flutter pub get && flutter run` 测试。** 🎉

## 如果问题仍然存在

请提供以下信息：

1. 运行 `flutter doctor -v` 的输出
2. 运行 `ls ~/Library/Android/sdk/ndk/` 的输出
3. 完整的错误日志

这将帮助进一步诊断问题。
