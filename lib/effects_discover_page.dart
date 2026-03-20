import 'dart:convert';
import 'package:auto_route/auto_route.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'models/effect_feed_model.dart';

@RoutePage()
class EffectsDiscoverPage extends StatefulWidget {
  final String type; // 'video' or 'image'
  const EffectsDiscoverPage({super.key, this.type = 'video'});

  @override
  State<EffectsDiscoverPage> createState() => _EffectsDiscoverPageState();
}

class _EffectsDiscoverPageState extends State<EffectsDiscoverPage> {
  static const _backgroundColor = Color(0xFF0D1018);
  static const _panelColor = Color(0xFF1B1F2B);
  static const _assetPath = 'assets/data/stream_response.txt';

  late final Future<EffectFeedModel> _feedFuture;
  final PageController _bannerController = PageController();
  final TextEditingController _searchController = TextEditingController();
  int _currentBannerIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<EffectFeedModel> _loadFeed() async {
    final source = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(source) as Map<String, dynamic>;
    return EffectFeedModel.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: _SearchBar(
                controller: _searchController,
                query: _searchQuery,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onClear: () {
                  _searchController.clear();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<EffectFeedModel>(
                future: _feedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '数据加载失败：${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final feed = snapshot.data;
                  if (feed == null) {
                    return const Center(
                      child: Text(
                        '暂无内容',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final query = _searchQuery.trim();
                  if (query.isNotEmpty) {
                    final results = _searchSections(
                        widget.type == 'video' ? feed.videos : feed.images, query);
                    return _buildSearchResults(query, results, feed);
                  }

                  final sections =
                      widget.type == 'video' ? feed.videos : feed.images;
                  final bannerSections =
                      sections.where((s) => s.isBanner && s.hasItems).toList();
                  final collectionSections =
                      sections.where((s) => !s.isBanner && s.hasItems).toList();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...bannerSections.map((section) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildBannerSection(section, feed),
                              const SizedBox(height: 28),
                            ],
                          )),
                      ...collectionSections.map((s) => _buildCollectionSection(s, feed)),
                      const SizedBox(height: 18),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  EffectSectionModel? _findBannerSection(List<EffectSectionModel> sections) {
    for (final section in sections) {
      if (section.isBanner && section.hasItems) {
        return section;
      }
    }
    return null;
  }

  Widget _buildBannerSection(EffectSectionModel section, EffectFeedModel feed) {
    final items = section.items;
    if (_currentBannerIndex >= items.length) {
      _currentBannerIndex = 0;
    }

    return AspectRatio(
      aspectRatio: 5 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _bannerController,
              itemCount: items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _showEffectDetailDialog(item, feed),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                    _NetworkImageFill(
                      imageUrl: item.bannerImageUrl,
                      staticImageUrl: item.bannerStaticImageUrl,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.10),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Text(
                        item.displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 18,
              bottom: 22,
              child: Row(
                children: List.generate(
                  items.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: index == _currentBannerIndex ? 9 : 8,
                    height: index == _currentBannerIndex ? 9 : 8,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: index == _currentBannerIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionSection(EffectSectionModel section, EffectFeedModel feed) {
    return _buildItemsSection(
      title: section.displayTitle,
      leadingEmoji: section.leadingEmoji,
      items: section.items,
      feed: feed,
    );
  }

  Widget _buildItemsSection({
    required String title,
    required List<EffectItemModel> items,
    required EffectFeedModel feed,
    String? leadingEmoji,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, leadingEmoji: leadingEmoji),
          const SizedBox(height: 14),
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = items[index];
                return SizedBox(
                  width: 160,
                  child: _EffectCard(
                    item: item,
                    panelColor: _panelColor,
                    onTap: () => _showEffectDetailDialog(item, feed),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String query, List<_SearchSectionResult> results, EffectFeedModel feed) {
    final resultCount = results.fold<int>(
      0,
      (sum, result) => sum + result.items.length,
    );

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off_rounded,
                color: Colors.white38,
                size: 54,
              ),
              const SizedBox(height: 14),
              Text(
                '没有找到 “$query” 相关模板',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '试试输入标题的一部分，比如 dance、pet、baby。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            '搜索 “$query” · $resultCount 个结果',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...results.map(
          (result) => _buildItemsSection(
            title: result.section.displayTitle,
            leadingEmoji: result.section.leadingEmoji,
            items: result.items,
            feed: feed,
          ),
        ),
      ],
    );
  }

  List<_SearchSectionResult> _searchSections(
    List<EffectSectionModel> sections,
    String query,
  ) {
    final results = <_SearchSectionResult>[];

    for (final section in sections) {
      final matched =
          section.items
              .map(
                (item) =>
                    (item: item, score: _fuzzyScore(query, item.displayTitle)),
              )
              .where((entry) => entry.score > 0)
              .toList()
            ..sort((a, b) => b.score.compareTo(a.score));

      if (matched.isNotEmpty) {
        results.add(
          _SearchSectionResult(
            section: section,
            items: matched.map((entry) => entry.item).toList(growable: false),
            bestScore: matched.first.score,
          ),
        );
      }
    }

    results.sort((a, b) => b.bestScore.compareTo(a.bestScore));
    return results;
  }

  int _fuzzyScore(String query, String title) {
    final rawQuery = query.trim().toLowerCase();
    final rawTitle = title.toLowerCase();
    final normalizedQuery = _normalizeSearchText(query);
    final normalizedTitle = _normalizeSearchText(title);

    if (normalizedQuery.isEmpty || normalizedTitle.isEmpty) {
      return 0;
    }

    if (rawTitle == rawQuery || normalizedTitle == normalizedQuery) {
      return 1200;
    }

    if (rawTitle.startsWith(rawQuery) ||
        normalizedTitle.startsWith(normalizedQuery)) {
      return 1000 - (normalizedTitle.length - normalizedQuery.length);
    }

    if (rawTitle.contains(rawQuery) ||
        normalizedTitle.contains(normalizedQuery)) {
      return 850 - (normalizedTitle.length - normalizedQuery.length);
    }

    final terms = rawQuery
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty);
    if (terms.isNotEmpty && terms.every(rawTitle.contains)) {
      return 700;
    }

    if (_isSubsequenceMatch(normalizedQuery, normalizedTitle)) {
      return 500 -
          (normalizedTitle.length - normalizedQuery.length).clamp(0, 300);
    }

    return 0;
  }

  String _normalizeSearchText(String value) {
    return value.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9\u4e00-\u9fa5]+'),
      '',
    );
  }

  bool _isSubsequenceMatch(String query, String candidate) {
    var queryIndex = 0;
    for (var i = 0; i < candidate.length; i++) {
      if (candidate[i] == query[queryIndex]) {
        queryIndex++;
        if (queryIndex == query.length) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _copyField(String label, String value) async {
    final text = value.trim();
    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label 已复制'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _copyAll(EffectItemModel item) async {
    final buffer = StringBuffer();

    final desc = item.description.trim();
    buffer.writeln('Prompt (提示词):');
    buffer.writeln(desc.isEmpty ? '-' : desc);

    if (item.inputImageUrls.isNotEmpty) {
      buffer.writeln('\nInput Images (输入图片):');
      for (var i = 0; i < item.inputImageUrls.length; i++) {
        buffer.writeln(item.inputImageUrls[i]);
      }
    }

    final text = buffer.toString().trim();
    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('素材已复制，去开启你的创作吧！'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _showEffectDetailDialog(EffectItemModel item, EffectFeedModel feed) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final coinText = item.coin?.toString() ?? '-';
        final description = item.description.trim().isEmpty ? '-' : item.description;
        final providerName = item.providerName.trim().isEmpty ? '-' : item.providerName;
        final imageUrls = item.inputImageUrls;

        // 获取标签名称
        final labels = <String>[];
        final allLabelModels = [...feed.videoLabels, ...feed.imageLabels];
        for (final labelId in item.labels) {
          final model = allLabelModels.where((l) => l.id == labelId).firstOrNull;
          if (model != null && model.title.isNotEmpty) {
            labels.add(model.title);
          }
        }

        return Dialog(
          backgroundColor: _panelColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: size.height * 0.84,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labels.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: labels.map((label) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3344),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Color(0xFFA855F7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _DetailField(
                          label: '模板名称',
                          value: item.displayTitle,
                          onCopy: () => _copyField('模板名称', item.displayTitle),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF232736),
                          foregroundColor: Colors.white70,
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (item.cardImageUrl != null) ...[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '生成结果图片',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: _NetworkImageFill(
                          imageUrl: item.cardImageUrl,
                          staticImageUrl: item.cardStaticImageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _DetailField(
                    label: '模型',
                    value: providerName,
                    onCopy: () => _copyField('模型', providerName),
                  ),
                  const SizedBox(height: 12),
                  _DetailField(
                    label: '消耗代币',
                    value: coinText,
                    onCopy: () => _copyField('消耗代币', coinText),
                  ),
                  const SizedBox(height: 12),
                  _DetailField(
                    label: '提示词',
                    value: description,
                    onCopy: () => _copyField('提示词', description),
                  ),
                  const SizedBox(height: 12),
                  if (imageUrls.isEmpty)
                    _DetailField(
                      label: '输入图片地址',
                      value: '-',
                      onCopy: () => _copyField('输入图片地址', '-'),
                    )
                  else
                    ...imageUrls.asMap().entries.map((entry) {
                      final index = entry.key;
                      final imageUrl = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == imageUrls.length - 1 ? 0 : 12,
                        ),
                        child: _InputImageCard(
                          index: index,
                          imageUrl: imageUrl,
                          onCopy: () =>
                              _copyField('输入图片地址 ${index + 1}', imageUrl),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyAll(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA855F7), // 紫色主题色
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded), // 使用创作图标
                      label: const Text(
                        '我要创作',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.leadingEmoji});

  final String title;
  final String? leadingEmoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingEmoji != null) ...[
          Text(leadingEmoji!, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF232736),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white70,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1F2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: '搜索模板标题',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white54,
            size: 22,
          ),
          suffixIcon: query.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SearchSectionResult {
  const _SearchSectionResult({
    required this.section,
    required this.items,
    required this.bestScore,
  });

  final EffectSectionModel section;
  final List<EffectItemModel> items;
  final int bestScore;
}

class _EffectCard extends StatelessWidget {
  const _EffectCard({
    required this.item,
    required this.panelColor,
    required this.onTap,
  });

  final EffectItemModel item;
  final Color panelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: panelColor),
              child: _NetworkImageFill(
                imageUrl: item.cardImageUrl,
                staticImageUrl: item.cardStaticImageUrl,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            if (item.badgeLabel != null)
              Positioned(
                left: 10,
                top: 12,
                child: _Badge(label: item.badgeLabel!),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.previewImages.isNotEmpty) ...[
                    _CardPreviewImages(previewImages: item.previewImages),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    item.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF232736),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onCopy,
            tooltip: '复制',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF2D3344),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.copy_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _InputImageCard extends StatelessWidget {
  const _InputImageCard({
    required this.index,
    required this.imageUrl,
    required this.onCopy,
  });

  final int index;
  final String imageUrl;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF232736),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailField(
            label: '输入图片地址 ${index + 1}',
            value: imageUrl,
            onCopy: onCopy,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: _NetworkImageFill(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPreviewImages extends StatelessWidget {
  const _CardPreviewImages({required this.previewImages});

  final List<String> previewImages;

  @override
  Widget build(BuildContext context) {
    final images = previewImages.take(2).toList(growable: false);
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardPreviewAvatar(imageUrl: images.first),
          if (images.length > 1) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _CardPreviewAvatar(imageUrl: images[1]),
          ],
        ],
      ),
    );
  }
}

class _CardPreviewAvatar extends StatelessWidget {
  const _CardPreviewAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final avatarCacheSize = (42 * devicePixelRatio).ceil();

    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: RepaintBoundary(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 120),
            placeholderFadeInDuration: Duration.zero,
            memCacheWidth: avatarCacheSize,
            memCacheHeight: avatarCacheSize,
            useOldImageOnUrlChange: true,
            filterQuality: FilterQuality.low,
            placeholder: (_, __) => const _ShimmerPlaceholder(
              shape: BoxShape.circle,
              backgroundColor: Color(0xFF3A4152),
              child: Icon(Icons.person, color: Colors.white38, size: 18),
            ),
            errorWidget: (_, __, ___) => const _PreviewAvatarFallback(),
          ),
        ),
      ),
    );
  }
}

class _PreviewAvatarFallback extends StatelessWidget {
  const _PreviewAvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3A4152),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: Colors.white54, size: 18),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  Color get _backgroundColor {
    switch (label) {
      case 'HOT':
        return const Color(0xFFCB37FF);
      case 'NEW':
        return const Color(0xFFFF8A3D);
      case 'POPULAR':
        return const Color(0xFF6AE45A);
      case 'FREE':
        return const Color(0xFF4C73FF);
      default:
        return const Color(0xFF495066);
    }
  }

  Color get _textColor {
    return label == 'POPULAR' ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _NetworkImageFill extends StatefulWidget {
  final String? imageUrl;
  final String? staticImageUrl;
  final BoxFit fit;

  const _NetworkImageFill({
    required this.imageUrl,
    this.staticImageUrl,
    this.fit = BoxFit.cover,
  });

  static const _maxCacheDimension = 2048;
  static const _visibleFractionThreshold = 0.15;
  static const _prewarmViewportMargin = 240.0;

  @override
  State<_NetworkImageFill> createState() => _NetworkImageFillState();
}

class _NetworkImageFillState extends State<_NetworkImageFill>
    with WidgetsBindingObserver {
  final Set<ScrollPosition> _observedPositions = <ScrollPosition>{};
  final Object _playbackToken = Object();
  bool _isVisible = false;
  bool _isAnimationGranted = false;
  bool _visibilityUpdateScheduled = false;
  _ResolvedImageCacheSize? _lastCacheSize;
  String? _prewarmingWebpKey;
  String? _prewarmedWebpKey;
  _ViewportState _viewportState = const _ViewportState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _androidWebpPlaybackController.addListener(_handlePlaybackBudgetChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindScrollPositions();
    _scheduleVisibilityUpdate();
  }

  @override
  void didUpdateWidget(covariant _NetworkImageFill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl ||
        widget.staticImageUrl != oldWidget.staticImageUrl) {
      _androidWebpPlaybackController.remove(_playbackToken);
      _prewarmingWebpKey = null;
      _prewarmedWebpKey = null;
      _isAnimationGranted = false;
      _scheduleVisibilityUpdate();
    }
  }

  @override
  void didChangeMetrics() {
    _scheduleVisibilityUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _androidWebpPlaybackController.removeListener(_handlePlaybackBudgetChanged);
    _androidWebpPlaybackController.remove(_playbackToken);
    for (final position in _observedPositions) {
      position.removeListener(_handleViewportChange);
    }
    _observedPositions.clear();
    super.dispose();
  }

  void _bindScrollPositions() {
    final positions = _collectAncestorScrollPositions();
    if (setEquals(positions, _observedPositions)) {
      return;
    }

    for (final position in _observedPositions.difference(positions)) {
      position.removeListener(_handleViewportChange);
    }

    for (final position in positions.difference(_observedPositions)) {
      position.addListener(_handleViewportChange);
    }

    _observedPositions
      ..clear()
      ..addAll(positions);
  }

  Set<ScrollPosition> _collectAncestorScrollPositions() {
    final positions = <ScrollPosition>{};

    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        positions.add((element.state as ScrollableState).position);
      }
      return true;
    });

    return positions;
  }

  void _handleViewportChange() {
    _scheduleVisibilityUpdate();
  }

  void _scheduleVisibilityUpdate() {
    if (!mounted || _visibilityUpdateScheduled) {
      return;
    }

    _visibilityUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityUpdateScheduled = false;
      if (!mounted) {
        return;
      }
      _updateVisibility();
    });
  }

  void _updateVisibility() {
    final viewportState = _calculateViewportState();
    _viewportState = viewportState;
    final isVisible =
        viewportState.visibleFraction >
        _NetworkImageFill._visibleFractionThreshold;

    if (viewportState.isNearViewport) {
      _maybePrewarmWebp();
    }

    _syncAndroidPlaybackBudget();

    if (isVisible == _isVisible) {
      return;
    }

    setState(() {
      _isVisible = isVisible;
    });
  }

  _ViewportState _calculateViewportState() {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return const _ViewportState();
    }

    final totalRect = MatrixUtils.transformRect(
      renderObject.getTransformTo(null),
      Offset.zero & renderObject.size,
    );
    if (totalRect.isEmpty) {
      return const _ViewportState();
    }

    final screenRect = Offset.zero & MediaQuery.sizeOf(context);
    final visibleRect = totalRect.intersect(screenRect);
    final totalArea = totalRect.width * totalRect.height;
    if (totalArea <= 0) {
      return const _ViewportState();
    }

    final visibleArea = visibleRect.isEmpty
        ? 0.0
        : visibleRect.width * visibleRect.height;
    final prewarmRect = screenRect.inflate(
      _NetworkImageFill._prewarmViewportMargin,
    );

    return _ViewportState(
      visibleFraction: visibleArea / totalArea,
      isNearViewport: totalRect.overlaps(prewarmRect),
      totalArea: totalArea,
      distanceToViewportCenter: (totalRect.center - screenRect.center).distance,
    );
  }

  void _syncAndroidPlaybackBudget() {
    if (!_shouldParticipateInAndroidPlaybackBudget) {
      _androidWebpPlaybackController.remove(_playbackToken);
      return;
    }

    _androidWebpPlaybackController.upsert(
      _AndroidWebpPlaybackCandidate(
        token: _playbackToken,
        score: _calculateAnimationScore(),
      ),
    );
  }

  bool get _shouldParticipateInAndroidPlaybackBudget {
    final webpUrl = widget.imageUrl?.trim() ?? '';
    final fallbackUrl = widget.staticImageUrl?.trim() ?? '';
    final isCurrentlyVisible =
        _viewportState.visibleFraction >
        _NetworkImageFill._visibleFractionThreshold;

    return defaultTargetPlatform == TargetPlatform.android &&
        isCurrentlyVisible &&
        webpUrl.toLowerCase().endsWith('.webp') &&
        fallbackUrl.isNotEmpty &&
        fallbackUrl != webpUrl;
  }

  double _calculateAnimationScore() {
    const visibleWeight = 1000000.0;
    const centerPenaltyWeight = 120.0;

    return _viewportState.visibleFraction * visibleWeight +
        _viewportState.totalArea -
        _viewportState.distanceToViewportCenter * centerPenaltyWeight;
  }

  void _handlePlaybackBudgetChanged() {
    final isGranted = _androidWebpPlaybackController.isGranted(_playbackToken);
    if (isGranted == _isAnimationGranted || !mounted) {
      return;
    }

    setState(() {
      _isAnimationGranted = isGranted;
    });
  }

  void _maybePrewarmWebp() {
    final webpUrl = widget.imageUrl?.trim() ?? '';
    final fallbackUrl = widget.staticImageUrl?.trim() ?? '';
    final cacheSize = _lastCacheSize;
    if (webpUrl.isEmpty ||
        cacheSize == null ||
        !webpUrl.toLowerCase().endsWith('.webp') ||
        fallbackUrl.isEmpty ||
        fallbackUrl == webpUrl) {
      return;
    }

    final prewarmKey =
        '$webpUrl:${cacheSize.width ?? 0}x${cacheSize.height ?? 0}';
    if (_prewarmedWebpKey == prewarmKey || _prewarmingWebpKey == prewarmKey) {
      return;
    }

    _prewarmingWebpKey = prewarmKey;

    final provider = ResizeImage.resizeIfNeeded(
      cacheSize.width,
      cacheSize.height,
      CachedNetworkImageProvider(webpUrl),
    );

    precacheImage(provider, context)
        .then((_) {
          if (!mounted || _prewarmingWebpKey != prewarmKey) {
            return;
          }
          _prewarmingWebpKey = null;
          _prewarmedWebpKey = prewarmKey;
        })
        .catchError((Object _) {
          if (_prewarmingWebpKey == prewarmKey) {
            _prewarmingWebpKey = null;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.imageUrl?.trim() ?? '';
    if (url.isEmpty) {
      return const _ImageFallback();
    }

    final resolvedUrl = _resolveImageUrl(url);
    final isWebp = resolvedUrl.toLowerCase().endsWith('.webp');

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cacheSize = _resolveCacheSize(context, constraints);
          _lastCacheSize = cacheSize;

          return CachedNetworkImage(
            imageUrl: resolvedUrl,
            fit: widget.fit,
            fadeOutDuration: Duration.zero,
            fadeInDuration: isWebp
                ? Duration.zero
                : const Duration(milliseconds: 240),
            placeholderFadeInDuration: Duration.zero,
            filterQuality: isWebp ? FilterQuality.none : FilterQuality.low,
            memCacheWidth: cacheSize.width,
            memCacheHeight: cacheSize.height,
            useOldImageOnUrlChange: true,
            placeholder: (_, __) =>
                const _ShimmerPlaceholder(child: _ImageFallback()),
            errorWidget: (_, __, ___) => const _ImageFallback(),
          );
        },
      ),
    );
  }

  String _resolveImageUrl(String url) {
    if (!url.toLowerCase().endsWith('.webp')) {
      return url;
    }

    final fallbackUrl = widget.staticImageUrl?.trim();
    if (fallbackUrl == null || fallbackUrl.isEmpty || fallbackUrl == url) {
      return url;
    }

    if (!_isVisible) {
      return fallbackUrl;
    }

    if (defaultTargetPlatform != TargetPlatform.android) {
      return url;
    }

    return _isAnimationGranted ? url : fallbackUrl;
  }

  _ResolvedImageCacheSize _resolveCacheSize(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return _ResolvedImageCacheSize(
      width: _toCacheDimension(
        constraints.hasBoundedWidth
            ? constraints.maxWidth * devicePixelRatio
            : null,
      ),
      height: _toCacheDimension(
        constraints.hasBoundedHeight
            ? constraints.maxHeight * devicePixelRatio
            : null,
      ),
    );
  }

  int? _toCacheDimension(double? value) {
    if (value == null || !value.isFinite || value <= 0) {
      return null;
    }

    return value.ceil().clamp(1, _NetworkImageFill._maxCacheDimension);
  }
}

class _ResolvedImageCacheSize {
  const _ResolvedImageCacheSize({this.width, this.height});

  final int? width;
  final int? height;
}

class _ViewportState {
  const _ViewportState({
    this.visibleFraction = 0,
    this.isNearViewport = false,
    this.totalArea = 0,
    this.distanceToViewportCenter = double.infinity,
  });

  final double visibleFraction;
  final bool isNearViewport;
  final double totalArea;
  final double distanceToViewportCenter;
}

class _AndroidWebpPlaybackCandidate {
  const _AndroidWebpPlaybackCandidate({
    required this.token,
    required this.score,
  });

  final Object token;
  final double score;
}

class _AndroidWebpPlaybackController extends ChangeNotifier {
  _AndroidWebpPlaybackController._();

  static final _AndroidWebpPlaybackController instance =
      _AndroidWebpPlaybackController._();
  static const _maxConcurrentAnimations = 6;

  final Map<Object, _AndroidWebpPlaybackCandidate> _entries =
      <Object, _AndroidWebpPlaybackCandidate>{};
  Set<Object> _activeTokens = <Object>{};

  bool isGranted(Object token) => _activeTokens.contains(token);

  void upsert(_AndroidWebpPlaybackCandidate candidate) {
    _entries[candidate.token] = candidate;
    _recompute();
  }

  void remove(Object token) {
    if (_entries.remove(token) == null) {
      return;
    }
    _recompute();
  }

  void _recompute() {
    final nextActiveTokens = _entries.values.toList(growable: false)
      ..sort((a, b) => b.score.compareTo(a.score));

    final activeTokens = nextActiveTokens
        .take(_maxConcurrentAnimations)
        .map((candidate) => candidate.token)
        .toSet();

    if (setEquals(activeTokens, _activeTokens)) {
      return;
    }

    _activeTokens = activeTokens;
    notifyListeners();
  }
}

final _androidWebpPlaybackController = _AndroidWebpPlaybackController.instance;

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFF2A3040)),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white38, size: 34),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  const _ShimmerPlaceholder({
    this.shape = BoxShape.rectangle,
    this.backgroundColor = const Color(0xFF2A3040),
    this.child,
  });

  final BoxShape shape;
  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1600),
      interval: const Duration(milliseconds: 120),
      color: Colors.white,
      colorOpacity: 0.18,
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor, shape: shape),
        child: Center(child: child),
      ),
    );
  }
}
