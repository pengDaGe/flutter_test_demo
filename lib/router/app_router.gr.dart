// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CounterPage]
class CounterRoute extends PageRouteInfo<void> {
  const CounterRoute({List<PageRouteInfo>? children})
    : super(CounterRoute.name, initialChildren: children);

  static const String name = 'CounterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CounterPage();
    },
  );
}

/// generated route for
/// [CreateVideoPage]
class CreateVideoRoute extends PageRouteInfo<void> {
  const CreateVideoRoute({List<PageRouteInfo>? children})
    : super(CreateVideoRoute.name, initialChildren: children);

  static const String name = 'CreateVideoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateVideoPage();
    },
  );
}

/// generated route for
/// [CyberOracleChooseRealityPage]
class CyberOracleChooseRealityRoute extends PageRouteInfo<void> {
  const CyberOracleChooseRealityRoute({List<PageRouteInfo>? children})
    : super(CyberOracleChooseRealityRoute.name, initialChildren: children);

  static const String name = 'CyberOracleChooseRealityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CyberOracleChooseRealityPage();
    },
  );
}

/// generated route for
/// [DiscoverMainPage]
class DiscoverMainRoute extends PageRouteInfo<void> {
  const DiscoverMainRoute({List<PageRouteInfo>? children})
    : super(DiscoverMainRoute.name, initialChildren: children);

  static const String name = 'DiscoverMainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DiscoverMainPage();
    },
  );
}

/// generated route for
/// [EffectsDiscoverPage]
class EffectsDiscoverRoute extends PageRouteInfo<EffectsDiscoverRouteArgs> {
  EffectsDiscoverRoute({
    Key? key,
    String type = 'video',
    List<PageRouteInfo>? children,
  }) : super(
         EffectsDiscoverRoute.name,
         args: EffectsDiscoverRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'EffectsDiscoverRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EffectsDiscoverRouteArgs>(
        orElse: () => const EffectsDiscoverRouteArgs(),
      );
      return EffectsDiscoverPage(key: args.key, type: args.type);
    },
  );
}

class EffectsDiscoverRouteArgs {
  const EffectsDiscoverRouteArgs({this.key, this.type = 'video'});

  final Key? key;

  final String type;

  @override
  String toString() {
    return 'EffectsDiscoverRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [LanguageSettingsPage]
class LanguageSettingsRoute extends PageRouteInfo<void> {
  const LanguageSettingsRoute({List<PageRouteInfo>? children})
    : super(LanguageSettingsRoute.name, initialChildren: children);

  static const String name = 'LanguageSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguageSettingsPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    bool showCloseButton = true,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, showCloseButton: showCloseButton),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginPage(key: args.key, showCloseButton: args.showCloseButton);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.showCloseButton = true});

  final Key? key;

  final bool showCloseButton;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, showCloseButton: $showCloseButton}';
  }
}

/// generated route for
/// [MyHomePage]
class MyHomeRoute extends PageRouteInfo<MyHomeRouteArgs> {
  MyHomeRoute({Key? key, required String title, List<PageRouteInfo>? children})
    : super(
        MyHomeRoute.name,
        args: MyHomeRouteArgs(key: key, title: title),
        initialChildren: children,
      );

  static const String name = 'MyHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyHomeRouteArgs>();
      return MyHomePage(key: args.key, title: args.title);
    },
  );
}

class MyHomeRouteArgs {
  const MyHomeRouteArgs({this.key, required this.title});

  final Key? key;

  final String title;

  @override
  String toString() {
    return 'MyHomeRouteArgs{key: $key, title: $title}';
  }
}

/// generated route for
/// [PodcastPage]
class PodcastRoute extends PageRouteInfo<void> {
  const PodcastRoute({List<PageRouteInfo>? children})
    : super(PodcastRoute.name, initialChildren: children);

  static const String name = 'PodcastRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PodcastPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [VibeoMainPage]
class VibeoMainRoute extends PageRouteInfo<void> {
  const VibeoMainRoute({List<PageRouteInfo>? children})
    : super(VibeoMainRoute.name, initialChildren: children);

  static const String name = 'VibeoMainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VibeoMainPage();
    },
  );
}

/// generated route for
/// [VideoGeneratingPage]
class VideoGeneratingRoute extends PageRouteInfo<void> {
  const VideoGeneratingRoute({List<PageRouteInfo>? children})
    : super(VideoGeneratingRoute.name, initialChildren: children);

  static const String name = 'VideoGeneratingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VideoGeneratingPage();
    },
  );
}

/// generated route for
/// [VideoResultPage]
class VideoResultRoute extends PageRouteInfo<void> {
  const VideoResultRoute({List<PageRouteInfo>? children})
    : super(VideoResultRoute.name, initialChildren: children);

  static const String name = 'VideoResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VideoResultPage();
    },
  );
}
