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
