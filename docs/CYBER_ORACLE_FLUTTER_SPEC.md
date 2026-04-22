# Cyber-Oracle Editorial · Flutter 落地规范

> **来源**：本规范由 [`/design.md`](../design.md) 派生，并通过 Stitch MCP
> 生成对应设计系统 (`assets/429940645877750812`，displayName: *Cyber-Oracle Editorial*)。
> 当前文档专门定义其在 **Flutter** 项目中的实现方式（Token / Theme / 组件 / 用法）。

---

## 0. 总览：The Neon Ritual

整个系统是一个 **永远 Dark Mode** 的「黑曜石数字仪式」：
- 不是普通工具型 UI，而是一种带有「神秘 + 高保真赛博朋克」氛围的体验；
- 拒绝模板化对称网格，使用 **故意的非对称** 布局；
- 字号要敢于「巨大」，让答案占据屏幕；
- 使用 **霓虹外发光** 与 **背景层级** 制造深度，禁止传统投影、禁止实线分割线、禁止纯白背景、禁止尖角。

---

## 1. 文件结构

```
lib/
  theme/
    cyber_oracle/
      cyber_oracle.dart            # 统一导出
      cyber_oracle_theme.dart      # ThemeData 工厂
      co_colors.dart               # 颜色 Token
      co_typography.dart           # 排版 Token (Display / Headline / Body / Label)
      co_spacing.dart              # 间距 + 圆角 Token
      co_effects.dart              # 玻璃 / 渐变 / Ambient Glow
  widgets/
    cyber_oracle/
      cyber_oracle_widgets.dart    # 统一导出
      co_glass_card.dart           # Glassmorphism 卡片
      co_buttons.dart              # Primary / Secondary / Tertiary
      co_hollow_input.dart         # Hollow 输入框
      co_mode_chip.dart            # 模式选择 Chip
      co_oracle_portal.dart        # Oracle Portal (主交互入口)
      co_section.dart              # Editorial 非对称段落
docs/
  CYBER_ORACLE_FLUTTER_SPEC.md     # 本文件
design.md                          # 原始设计规范
```

---

## 2. 接入步骤

### 2.1 字体

在 `pubspec.yaml` 中接入三套字体（推荐使用 [`google_fonts`](https://pub.dev/packages/google_fonts) 包动态加载，
或将字体文件放入 `assets/fonts/` 中并在 `pubspec.yaml` 注册）。

#### 方案 A：本地字体（推荐，离线可用）

```yaml
flutter:
  fonts:
    - family: SpaceGrotesk
      fonts:
        - asset: assets/fonts/SpaceGrotesk-Regular.ttf
        - asset: assets/fonts/SpaceGrotesk-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/SpaceGrotesk-Bold.ttf
          weight: 700
    - family: Manrope
      fonts:
        - asset: assets/fonts/Manrope-Regular.ttf
        - asset: assets/fonts/Manrope-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Manrope-Bold.ttf
          weight: 700
    - family: PlusJakartaSans
      fonts:
        - asset: assets/fonts/PlusJakartaSans-Regular.ttf
        - asset: assets/fonts/PlusJakartaSans-Medium.ttf
          weight: 500
```

#### 方案 B：`google_fonts`

```dart
import 'package:google_fonts/google_fonts.dart';

// 在 CoTypography 中将 oracleFamily/humanFamily/dataFamily 替换为：
GoogleFonts.spaceGrotesk().fontFamily!
GoogleFonts.manrope().fontFamily!
GoogleFonts.plusJakartaSans().fontFamily!
```

### 2.2 启用主题

```dart
import 'package:flutter_test_demo/theme/cyber_oracle/cyber_oracle.dart';

MaterialApp(
  themeMode: ThemeMode.dark,
  darkTheme: CyberOracleTheme.dark(),
  home: const HomePage(),
);
```

### 2.3 切换 Accent（Mode）

```dart
// 用户选择 Wealth 模式 → 主题强调色切到金色
final theme = CyberOracleTheme.dark(accent: CoAccentMode.wealth);
```

> 推荐结合现有 `lib/theme/theme_controller.dart` 的 GetX 控制器
> 暴露一个 `Rx<CoAccentMode>` 状态，并在 `MaterialApp.theme` 处响应式重建。

---

## 3. 颜色 Token（与 Material 3 角色映射）

| Token (Dart)                          | Hex / 公式                          | M3 对应                    | 用途                                  |
| ------------------------------------- | ----------------------------------- | -------------------------- | ------------------------------------- |
| `CoColors.surface`                    | `#0E0E0E`                           | `surface`                  | 主画布                                |
| `CoColors.surfaceContainerLow`        | `#161616`                           | `surfaceContainerLow`      | 二级内容块                            |
| `CoColors.surfaceContainer`           | `#1C1C1F`                           | `surfaceContainer`         | Card 默认背景                         |
| `CoColors.surfaceContainerHigh`       | `#24242A`                           | `surfaceContainerHigh`     | 嵌套 Card                             |
| `CoColors.surfaceContainerHighest`    | `#2C2C34`                           | `surfaceContainerHighest`  | 顶层交互元素                          |
| `CoColors.surfaceBright`              | `#35353F`                           | `surfaceBright`            | 高亮容器                              |
| `CoColors.surfaceVariant`             | `#2A2A33`                           | `surfaceVariant`           | Glassmorphism 基色（配 40% alpha）    |
| `CoColors.onSurface`                  | `#EDE9F2`（**非纯白**）             | `onSurface`                | 主文字                                |
| `CoColors.onSurfaceVariant`           | `#B7B0C5`                           | `onSurfaceVariant`         | 次级文字                              |
| `CoColors.onSurfaceMuted`             | `#6F6A82`                           | -                          | metadata / disabled                   |
| `CoColors.primary`                    | `#DE8EFF`                           | `primary`                  | The Action                            |
| `CoColors.primaryDim`                 | `#B36BD9`                           | -                          | Ambient Glow 边缘光晕                 |
| `CoColors.primaryFixed`               | `#E9B6FF`                           | `primaryFixed`             | Tertiary 文本按钮                     |
| `CoColors.secondary`                  | `#FF3B6B`（霓虹红）                 | `secondary`                | Savage Mode                           |
| `CoColors.secondaryDim`               | `#D93060`                           | -                          | Savage Mode 外发光                    |
| `CoColors.tertiary`                   | `#F2C14E`（赛博金）                 | `tertiary`                 | Wealth Mode                           |
| `CoColors.tertiaryDim`                | `#C99A2E`                           | -                          | Wealth Mode 外发光                    |
| `CoColors.outlineVariant`             | `onSurface @ 15% opacity`           | `outlineVariant`           | **Ghost Border**（输入框、玻璃描边）  |

### 3.1 No-Line Rule（强制）

**禁止** 使用 1px 实线 `Divider` 切分内容。仅允许 3 种分区方式：
1. **背景层级切换**：`surface` → `surfaceContainerLow`；
2. **霓虹外发光**：用 `CoEffects.ambientGlow(color: CoColors.primaryDim)` 标识容器边缘；
3. **大间距**：`CoSpacing.xl` / `CoSpacing.xxl` 制造留白。

> `CyberOracleTheme.dark()` 已经将 `dividerTheme` 强制为透明、`thickness: 0`。

---

## 4. 排版 Token

| Dart Token                     | Family             | Size / Weight / LH  | 用途                                      |
| ------------------------------ | ------------------ | ------------------- | ----------------------------------------- |
| `CoTypography.displayLg`       | Space Grotesk 700  | 72 / 1.0 / -0.04em  | 单字答案 ("YES")                          |
| `CoTypography.displayMd`       | Space Grotesk 700  | 56 / 1.05 / -0.03em | Hero 标题                                 |
| `CoTypography.displaySm`       | Space Grotesk 700  | 44 / 1.1 / -0.02em  | 「答案」次级                              |
| `CoTypography.headlineLg`      | Space Grotesk 700  | 34 / 1.15           | 「答案」核心                              |
| `CoTypography.headlineMd`      | Space Grotesk 600  | 28 / 1.2            | 卡片大标题                                |
| `CoTypography.headlineSm`      | Space Grotesk 600  | 22 / 1.25           | Hollow Input 文本                         |
| `CoTypography.titleLg/Md/Sm`   | Manrope 600        | 20 / 16 / 14        | 卡片 / 列表标题                           |
| `CoTypography.bodyLg/Md/Sm`    | Manrope 400        | 16 / 14 / 12        | 长「fortune」、Savage 文案、sarcasm 注释  |
| `CoTypography.labelLg/Md/Sm`   | Plus Jakarta 500   | 14 / 12 / 10        | 数据 / metadata / 按钮文字                |

**规范用法：**
- 「答案」**始终** 使用 `headlineLg` 或 `displaySm`；
- sarcasm/context 使用 `bodySm`，对齐到右下，构成编辑性气息；
- AppBar / 按钮文字使用 `labelLg`。

---

## 5. 间距 / 圆角

```dart
CoSpacing.xs   // 4
CoSpacing.sm   // 8
CoSpacing.md   // 16   ← 列表行间最小垂直距离
CoSpacing.lg   // 24
CoSpacing.xl   // 40   ← Section 之间「呼吸」
CoSpacing.xxl  // 64
CoSpacing.xxxl // 96

CoRadius.sm   // 24    ← 系统最小圆角（don't 列表的下限）
CoRadius.md   // 28    ← Card 默认
CoRadius.lg   // 36    ← Modal / Hero
CoRadius.pill // 999   ← Chip / Pill
```

---

## 6. 视觉效果

### 6.1 Glassmorphism

```dart
CoGlassCard(
  glow: CoEffects.fabGlow,        // 可选：增加 Ambient Glow
  gradientOverlay: true,          // 默认开启「digital soul」渐变
  child: ...,
);
```

实现公式：`surfaceVariant @ 40%` + `BackdropFilter(20px)` + 顶部 1px Inner Glow。

### 6.2 Ambient Glow（**禁止用 `BoxShadow` 模拟阴影**）

```dart
// 通用 API：
CoEffects.ambientGlow(
  color: CoColors.primaryDim,  // 或 secondaryDim / tertiaryDim
  opacity: 0.10,
  blur: 40,
);

// 预设：
CoEffects.fabGlow      // FAB
CoEffects.savageGlow   // Savage Mode Card
CoEffects.wealthGlow   // Wealth Mode Card
```

### 6.3 渐变叠层

`CoEffects.cardSoulOverlay` —— `primary → primaryContainer @ 15%`，
默认在 `CoGlassCard` 中自动叠加，亦可用于自定义容器。

`CoEffects.portalRingGradient` —— 用于 Oracle Portal 的旋转描边。

---

## 7. 组件规范

### 7.1 Buttons

| 组件                  | 用途       | 视觉                                                |
| --------------------- | ---------- | --------------------------------------------------- |
| `CoPrimaryButton`     | The Action | `primary` 填充，`onPrimary` 文字，圆角 `CoRadius.sm`，可加 `withGlow: true` |
| `CoSecondaryButton`   | The Choice | Glassmorphism 背景 + Primary 20% Ghost Border       |
| `CoTertiaryButton`    | The Subtle | 纯文字，`primaryFixed` 颜色                         |

### 7.2 Cards

> **唯一允许的卡片模式** = `CoGlassCard` 或基于 `surfaceContainer*` 的纯色卡片。
> **必须** 比父容器更亮一层（lift 视觉）。

```dart
// Savage Mode 卡片
CoGlassCard(
  glow: CoEffects.savageGlow,
  child: ...,
);
```

### 7.3 Hollow Input

```dart
CoHollowInput(
  hint: 'Ask the void…',
  onSubmitted: (q) => controller.consult(q),
);
```

无背景填充；仅底部 Ghost Border；输入文本 `headlineSm`。

### 7.4 Mode Chip

```dart
CoModeChipBar(
  current: state.mode,
  onChanged: (m) {
    state.mode = m;
    // 重建 MaterialApp 以应用新的 accent
  },
);
```

> Chip 选中后必须 **重建顶层 Theme**，从而把整个 App 的 accent 切到 `CoColors.accentForMode(mode)`。
> 与 GetX 配合时，可在 `theme_controller.dart` 中暴露 `Rx<CoAccentMode>`，
> 并在 `GetMaterialApp` 的 `theme` 中读取。

### 7.5 Oracle Portal

```dart
CoOraclePortal(
  size: 280,
  thinking: state.isLoading.value,    // 旋转描边
  onTap: () => state.consult(),
  child: Text('?', style: CoTypography.displayLg),
);
```

### 7.6 Editorial Section（非对称段落）

```dart
CoEditorialSection(
  headline: 'YES.',
  context_: '— consult cards drawn at 03:14 a.m.',
);
```

---

## 8. Do's & Don'ts（落地清单）

### Do
- ✅ 使用 `CoEditorialSection` / 自定义 `Stack + Positioned` 制造 **非对称** 排版；
- ✅ 重要元素叠加 `CoEffects.ambientGlow(...)`，让光「溢出」到周围像素；
- ✅ 用 `displayLg` / `displayMd` 渲染答案，**敢占满屏幕**；
- ✅ 使用 `CoGlassCard` 作为浮层模态、底部抽屉、AppBar；
- ✅ 用 `surface` 层级嵌套表达深度（父亮度 < 子亮度）。

### Don't
- ❌ 禁止使用 `Colors.white` 作为背景或文字主色（请用 `CoColors.onSurface = #EDE9F2`）；
- ❌ 禁止使用 `Divider()` / `Border(width: 1, color: ...)` 作为分区手段；
- ❌ 禁止使用尖角，所有 `BorderRadius` ≥ `CoRadius.sm` (24)；
- ❌ 禁止使用 `BoxShadow` 模拟传统投影 —— 改用 Tonal Layering 或 Ambient Glow；
- ❌ 禁止使用厚重的不透明边框；
- ❌ 禁止给图标 / 容器添加任何 `Material 2` 风格的 ripple `splashColor`（使用 `InkSparkle`，已在主题中默认）。

---

## 9. 对应 Stitch 资源

- **Asset Name**：`assets/429940645877750812`
- **Display Name**：`Cyber-Oracle Editorial`
- **Color Mode**：`DARK`
- **Color Variant**：`EXPRESSIVE`
- **Headline / Body / Label Font**：`SPACE_GROTESK / MANROPE / PLUS_JAKARTA_SANS`
- **Roundness**：`ROUND_TWELVE`
- **Override Primary / Secondary / Tertiary / Neutral**：
  `#DE8EFF / #FF3B6B / #F2C14E / #0E0E0E`

如需将该设计系统应用到 Stitch 上的某些 Screens，使用 `apply_design_system`
工具并传入上述 `assetId`。

---

## 10. 示例：从 0 拼一个「问神谕」屏

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test_demo/theme/cyber_oracle/cyber_oracle.dart';
import 'package:flutter_test_demo/widgets/cyber_oracle/cyber_oracle_widgets.dart';

class OraclePage extends StatelessWidget {
  const OraclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: CoSpacing.xl),

            CoEditorialSection(
              headline: 'YES.',
              context_: '— the cards say so, drawn at 03:14 a.m.',
            ),

            const SizedBox(height: CoSpacing.xxl),

            Center(
              child: CoOraclePortal(
                size: 260,
                thinking: false,
                onTap: () {},
                child: const Text('?',
                    style: TextStyle(
                      fontSize: 96,
                      fontFamily: CoTypography.oracleFamily,
                      color: CoColors.onSurface,
                    )),
              ),
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: CoSpacing.lg),
              child: CoHollowInput(hint: 'Ask the void…'),
            ),

            const SizedBox(height: CoSpacing.lg),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CoSpacing.lg),
              child: CoPrimaryButton(
                label: 'Consult',
                expand: true,
                withGlow: true,
                onPressed: () {},
              ),
            ),

            const SizedBox(height: CoSpacing.xl),
          ],
        ),
      ),
    );
  }
}
```
