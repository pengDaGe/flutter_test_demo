import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'models/effect_feed_model.dart';

class EffectsDiscoverPage extends StatefulWidget {
  const EffectsDiscoverPage({super.key});

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
                    final results = _searchSections(feed.videos, query);
                    return _buildSearchResults(query, results);
                  }

                  final bannerSection = _findBannerSection(feed.videos);
                  final collectionSections = feed.videos
                      .where(
                        (section) => section.isCollection && section.hasItems,
                      )
                      .toList(growable: false);

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (bannerSection != null) ...[
                        _buildBannerSection(bannerSection),
                        const SizedBox(height: 28),
                      ],
                      ...collectionSections.map(_buildCollectionSection),
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

  Widget _buildBannerSection(EffectSectionModel section) {
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
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _NetworkImageFill(imageUrl: item.bannerImageUrl),
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

  Widget _buildCollectionSection(EffectSectionModel section) {
    return _buildItemsSection(
      title: section.displayTitle,
      leadingEmoji: section.leadingEmoji,
      items: section.items,
    );
  }

  Widget _buildItemsSection({
    required String title,
    required List<EffectItemModel> items,
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
                    onTap: () => _showEffectDetailDialog(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String query, List<_SearchSectionResult> results) {
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

  Future<void> _showEffectDetailDialog(EffectItemModel item) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final coinText = item.coin?.toString() ?? '-';
        final description = item.description.trim().isEmpty
            ? '-'
            : item.description;
        final providerName = item.providerName.trim().isEmpty
            ? '-'
            : item.providerName;
        final imageUrls = item.inputImageUrls;

        return Dialog(
          backgroundColor: _panelColor,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: _NetworkImageFill(imageUrl: item.cardImageUrl),
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
              child: _NetworkImageFill(imageUrl: item.cardImageUrl),
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
              child: _NetworkImageFill(imageUrl: imageUrl),
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 220),
          placeholder: (_, __) => const _ShimmerPlaceholder(
            shape: BoxShape.circle,
            backgroundColor: Color(0xFF3A4152),
            child: Icon(Icons.person, color: Colors.white38, size: 18),
          ),
          errorWidget: (_, __, ___) => const _PreviewAvatarFallback(),
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

class _NetworkImageFill extends StatelessWidget {
  const _NetworkImageFill({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return const _ImageFallback();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 240),
      placeholder: (_, __) =>
          const _ShimmerPlaceholder(child: _ImageFallback()),
      errorWidget: (_, __, ___) => const _ImageFallback(),
    );
  }
}

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
