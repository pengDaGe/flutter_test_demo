class EffectFeedModel {
  const EffectFeedModel({
    required this.videoLabels,
    required this.imageLabels,
    required this.videos,
    required this.images,
  });

  final List<EffectLabelModel> videoLabels;
  final List<EffectLabelModel> imageLabels;
  final List<EffectSectionModel> videos;
  final List<EffectSectionModel> images;

  factory EffectFeedModel.fromJson(Map<String, dynamic> json) {
    return EffectFeedModel(
      videoLabels: _parseList(
        json['videoLabels'],
        (item) => EffectLabelModel.fromJson(item),
      ),
      imageLabels: _parseList(
        json['imageLabels'],
        (item) => EffectLabelModel.fromJson(item),
      ),
      videos: _parseList(
        json['videos'],
        (item) => EffectSectionModel.fromJson(item),
      ),
      images: _parseList(
        json['images'],
        (item) => EffectSectionModel.fromJson(item),
      ),
    );
  }
}

class EffectLabelModel {
  const EffectLabelModel({
    required this.id,
    required this.title,
    required this.iconUrl,
  });

  final int id;
  final String title;
  final String iconUrl;

  factory EffectLabelModel.fromJson(Map<String, dynamic> json) {
    return EffectLabelModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
    );
  }
}

class EffectSectionModel {
  const EffectSectionModel({
    required this.title,
    required this.viewType,
    required this.isTitleVisible,
    required this.items,
  });

  final String title;
  final String viewType;
  final bool isTitleVisible;
  final List<EffectItemModel> items;

  bool get isBanner => viewType.toLowerCase() == 'banner';

  bool get isCollection => viewType.toLowerCase() == 'collection';

  bool get hasItems => items.isNotEmpty;

  String get displayTitle =>
      title.replaceAll('🔥', '').replaceAll('🐶', '').trim();

  String? get leadingEmoji {
    if (title.contains('🔥')) {
      return '🔥';
    }
    return null;
  }

  factory EffectSectionModel.fromJson(Map<String, dynamic> json) {
    return EffectSectionModel(
      title: json['title'] as String? ?? '',
      viewType: json['viewType'] as String? ?? '',
      isTitleVisible: json['isTitleVisible'] as bool? ?? true,
      items: _parseList(
        json['items'],
        (item) => EffectItemModel.fromJson(item),
      ),
    );
  }
}

class EffectItemModel {
  const EffectItemModel({
    required this.effectStyleId,
    required this.title,
    required this.badgeType,
    required this.isNew,
    required this.description,
    required this.previewImages,
    required this.bannerPreviewWebpUrl,
    required this.bannerPreviewWebpUrlV2,
    required this.collectionPreviewImgUrlV2,
    required this.collectionPreviewWebpUrl,
    required this.collectionPreviewWebpUrlV2,
    required this.bannerPreviewImageUrl,
    required this.labels,
    required this.providers,
  });

  final int effectStyleId;
  final String title;
  final String? badgeType;
  final bool isNew;
  final String description;
  final List<String> previewImages;
  final String? bannerPreviewWebpUrl;
  final String? bannerPreviewWebpUrlV2;
  final String? collectionPreviewImgUrlV2;
  final String? collectionPreviewWebpUrl;
  final String? collectionPreviewWebpUrlV2;
  final String? bannerPreviewImageUrl;
  final List<int> labels;
  final List<EffectProviderModel> providers;

  String get displayTitle => title.trim().isEmpty ? 'Untitled' : title.trim();

  String? get badgeLabel {
    if (isNew) {
      return 'NEW';
    }
    final value = badgeType?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value.toUpperCase();
  }

  String? get bannerImageUrl => _firstNonEmpty([
    bannerPreviewImageUrl,
    bannerPreviewWebpUrlV2,
    bannerPreviewWebpUrl,
    collectionPreviewImgUrlV2,
    collectionPreviewWebpUrlV2,
    collectionPreviewWebpUrl,
    ...previewImages,
  ]);

  String? get bannerStaticImageUrl =>
      _firstNonWebp([collectionPreviewImgUrlV2, ...previewImages]);

  String? get cardImageUrl => _firstNonEmpty([
    bannerPreviewImageUrl,
    collectionPreviewWebpUrlV2,
    collectionPreviewImgUrlV2,
    collectionPreviewWebpUrl,
    bannerPreviewWebpUrlV2,
    bannerPreviewWebpUrl,
    ...previewImages,
  ]);

  String? get cardStaticImageUrl =>
      _firstNonWebp([collectionPreviewImgUrlV2, ...previewImages]);

  EffectProviderModel? get primaryProvider =>
      providers.isEmpty ? null : providers.first;

  String get providerName => primaryProvider?.name ?? '';

  int? get coin => providers.isEmpty ? null : providers.first.coin;

  List<String> get inputImageUrls => previewImages;

  factory EffectItemModel.fromJson(Map<String, dynamic> json) {
    return EffectItemModel(
      effectStyleId: json['effectStyleId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      badgeType: json['badgeType'] as String?,
      isNew: json['isNew'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      previewImages: _parseStringList(json['previewImages']),
      bannerPreviewWebpUrl: json['bannerPreviewWebpUrl'] as String?,
      bannerPreviewWebpUrlV2: json['bannerPreviewWebpUrlV2'] as String?,
      collectionPreviewImgUrlV2: json['collectionPreviewImgUrlV2'] as String?,
      collectionPreviewWebpUrl: json['collectionPreviewWebpUrl'] as String?,
      collectionPreviewWebpUrlV2: json['collectionPreviewWebpUrlV2'] as String?,
      bannerPreviewImageUrl: json['bannerPreviewImageUrl'] as String?,
      labels: (json['labels'] as List?)?.cast<int>() ?? const [],
      providers: _parseList(
        json['providers'],
        (item) => EffectProviderModel.fromJson(item),
      ),
    );
  }
}

class EffectProviderModel {
  const EffectProviderModel({
    required this.id,
    required this.name,
    required this.coin,
    required this.hasSound,
  });

  final int id;
  final String name;
  final int coin;
  final bool hasSound;

  factory EffectProviderModel.fromJson(Map<String, dynamic> json) {
    return EffectProviderModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      coin: json['coin'] as int? ?? 0,
      hasSound: json['hasSound'] as bool? ?? false,
    );
  }
}

List<T> _parseList<T>(
  dynamic source,
  T Function(Map<String, dynamic> json) parser,
) {
  if (source is! List) {
    return const [];
  }

  return source
      .whereType<Map<String, dynamic>>()
      .map(parser)
      .toList(growable: false);
}

List<String> _parseStringList(dynamic source) {
  if (source is! List) {
    return const [];
  }

  return source
      .whereType<String>()
      .where((item) => item.trim().isNotEmpty)
      .toList(growable: false);
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) {
      return value;
    }
  }
  return null;
}

String? _firstNonWebp(List<String?> values) {
  for (final value in values) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      continue;
    }

    if (!normalized.toLowerCase().endsWith('.webp')) {
      return normalized;
    }
  }

  return null;
}
