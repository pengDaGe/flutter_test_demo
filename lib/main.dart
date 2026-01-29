import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_test_demo/l10n/app_strings.dart';
import 'package:get/get.dart' hide Trans; // 隐藏 GetX 的 Trans 扩展
import 'l10n/app_translations.dart';
import 'l10n/language_controller.dart';
import 'l10n/language_helper.dart';
import 'l10n/translation_service.dart'; // 翻译服务
import 'router/app_router.dart';
import 'utils/router_helper.dart';
import 'theme/app_themes.dart'; // ✅ 导入应用主题
import 'theme/theme_helper.dart'; // ✅ 导入主题工具类
import 'theme/theme_controller.dart'; // ✅ 导入主题控制器
import 'utils/logger.dart'; // ✅ 导入日志工具类
import 'utils/toast_utils.dart'; // ✅ 导入 Toast 工具类


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.init(); // ✅ 初始化日志工具类
  await LanguageHelper.init(); // 初始化语言
  ThemeHelper.init(); // ✅ 初始化主题
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // 创建路由器实例
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // 初始化路由工具类
    RouterHelper.init(_appRouter);
    final languageController = Get.find<LanguageController>();
    final themeController = Get.find<ThemeController>(); // ✅ 获取主题控制器

    // 使用 Obx 监听语言和主题变化
    return Obx(() {
      // 获取当前语言和主题模式（确保 Obx 追踪这些变量）
      final currentLocale = languageController.currentLocale;
      final themeMode = themeController.themeMode.value;

      return ToastUtils.init(
        MaterialApp.router(
          title: 'Flutter Demo',

          // 使用当前语言
          locale: currentLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
            Locale('en', 'US'),
            Locale('ja', 'JP'),
          ],

          // ✅ 配置主题
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeController.getThemeMode(),

          // AutoRoute 路由配置
          routerConfig: _appRouter.config(),
        ),
      );
    });
  }
}

@RoutePage()
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(() => Text(AppStrings.home.tr)),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 跳转到 GetX 计数器示例页面
          // RouterHelper.push(CounterRoute());
          RouterHelper.push(LanguageSettingsRoute());
        },
        tooltip: '打开计数器',
        child: const Icon(Icons.calculate),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
