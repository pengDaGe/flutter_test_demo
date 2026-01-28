import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;  // 隐藏 GetX 的 Trans 扩展
import 'package:auto_route/auto_route.dart';
import '../l10n/app_strings.dart';  // ✅ 导入 AppStrings
import '../l10n/language_controller.dart';
import '../l10n/language_helper.dart';
import '../l10n/translation_service.dart';  // 添加自定义翻译服务
import '../theme/theme_controller.dart'; // ✅ 导入主题控制器
import '../theme/theme_helper.dart'; // ✅ 导入主题工具类

/// 语言与主题设置页面
@RoutePage()
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.language.tr} & ${AppStrings.theme.tr}'), // ✅ 显示语言与主题
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 主题设置卡片
            _buildThemeCard(themeController),

            // 当前语言显示
            _buildCurrentLanguageCard(langController),

            const SizedBox(height: 16),

            // 语言列表 (固定高度，因为在 SingleChildScrollView 中)
            SizedBox(
              height: 300,
              child: _buildLanguageList(langController),
            ),

            // 测试翻译区域
            _buildTestTranslationCard(),
          ],
        ),
      ),
    );
  }

  /// 主题设置卡片
  Widget _buildThemeCard(ThemeController controller) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_outlined),
                const SizedBox(width: 8),
                Text(
                  AppStrings.theme.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => SegmentedButton<AppThemeMode>(
                  segments: <ButtonSegment<AppThemeMode>>[
                    ButtonSegment<AppThemeMode>(
                      value: AppThemeMode.light,
                      label: Text(AppStrings.theme.tr), // 这里可以添加亮色翻译
                      icon: const Icon(Icons.light_mode),
                    ),
                    ButtonSegment<AppThemeMode>(
                      value: AppThemeMode.dark,
                      label: const Text('Dark'), // 这里可以添加暗色翻译
                      icon: const Icon(Icons.dark_mode),
                    ),
                    ButtonSegment<AppThemeMode>(
                      value: AppThemeMode.system,
                      label: const Text('System'),
                      icon: const Icon(Icons.brightness_auto),
                    ),
                  ],
                  selected: <AppThemeMode>{controller.themeMode.value},
                  onSelectionChanged: (Set<AppThemeMode> newSelection) {
                    controller.setThemeMode(newSelection.first);
                  },
                )),
          ],
        ),
      ),
    );
  }

  /// 当前语言卡片
  Widget _buildCurrentLanguageCard(LanguageController controller) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectLanguage.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
                  children: [
                    const Icon(Icons.language, size: 32, color: Colors.blue),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentLanguage.value.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.currentLanguage.value.code,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  /// 语言列表
  Widget _buildLanguageList(LanguageController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: controller.supportedLanguages.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final language = controller.supportedLanguages[index];
          return Obx(() {
            final isSelected = controller.currentLanguage.value == language;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    isSelected ? Colors.blue : Colors.grey[300],
                child: Text(
                  _getLanguageFlag(language),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                language.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
              subtitle: Text(language.code),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
              onTap: () => controller.changeLanguage(language),
            );
          });
        },
      ),
    );
  }

  /// 测试翻译卡片
  Widget _buildTestTranslationCard() {
    final controller = Get.find<LanguageController>();
    
    return Obx(() {
      // 显式访问响应式变量，让 GetX 追踪
      final currentLang = controller.currentLanguage.value;
      
      return Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Translation Test (${currentLang.name})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTranslationChip('loginTitle'),
                  _buildTranslationChip('welcome'),
                  _buildTranslationChip('settings'),
                  _buildTranslationChip('confirm'),
                  _buildTranslationChip('cancel'),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 翻译芯片
  Widget _buildTranslationChip(String key) {
    return Chip(
      label: Text('$key: ${key.tr}'),
      backgroundColor: Colors.blue[50],
    );
  }

  /// 获取语言旗帜表情
  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.zhCN:
        return '🇨🇳';
      case AppLanguage.zhTW:
        return '🇹🇼';
      case AppLanguage.en:
        return '🇺🇸';
      case AppLanguage.ja:
        return '🇯🇵';
    }
  }
}

/// 简单的语言切换按钮组件
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageController>();

    return Obx(() => PopupMenuButton<AppLanguage>(
          icon: const Icon(Icons.language),
          tooltip: AppStrings.language.tr,
          onSelected: (language) => controller.changeLanguage(language),
          itemBuilder: (context) => controller.supportedLanguages
              .map((language) => PopupMenuItem<AppLanguage>(
                    value: language,
                    child: Row(
                      children: [
                        Text(
                          _getLanguageFlag(language),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(language.name),
                        if (controller.currentLanguage.value == language) ...[
                          const Spacer(),
                          const Icon(Icons.check, color: Colors.blue),
                        ],
                      ],
                    ),
                  ))
              .toList(),
        ));
  }

  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.zhCN:
        return '🇨🇳';
      case AppLanguage.zhTW:
        return '🇹🇼';
      case AppLanguage.en:
        return '🇺🇸';
      case AppLanguage.ja:
        return '🇯🇵';
    }
  }
}
