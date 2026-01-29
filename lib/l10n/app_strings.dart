/// 应用翻译字符串常量
/// 
/// 提供类型安全的翻译 key，支持 IDE 自动补全
/// 
/// 使用方式：
/// ```dart
/// Text(AppStrings.loginTitle.tr)
/// Text(AppStrings.welcome.tr)
/// ```
class AppStrings {
  AppStrings._(); // 私有构造函数，防止实例化

  // ==================== 认证相关 ====================
  
  /// 登录标题
  static const String loginTitle = 'loginTitle';
  
  /// 用户名
  static const String username = 'username';
  
  /// 密码
  static const String password = 'password';
  
  /// 登录按钮
  static const String login = 'login';
  
  /// 退出登录
  static const String logout = 'logout';
  
  /// 注册
  static const String register = 'register';
  
  /// 忘记密码
  static const String forgotPassword = 'forgotPassword';

  /// 欢迎来到 Nice AI
  static const String welcomeToNiceAI = 'welcomeToNiceAI';

  /// 您的全能 AI 助手
  static const String allInOneAIAssistant = 'allInOneAIAssistant';

  /// 使用 Google 登录
  static const String continueWithGoogle = 'continueWithGoogle';

  /// 使用 Apple 登录
  static const String continueWithApple = 'continueWithApple';

  /// 使用 Facebook 登录
  static const String continueWithFacebook = 'continueWithFacebook';

  /// 使用电子邮箱登录
  static const String continueWithEmail = 'continueWithEmail';

  /// 如果您正在创建新账户
  static const String creatingNewAccount = 'creatingNewAccount';

  /// 服务条款
  static const String termsConditions = 'termsConditions';

  /// 隐私政策
  static const String privacyPolicy = 'privacyPolicy';

  /// 将会适用
  static const String willApply = 'willApply';

  /// 和
  static const String and = 'and';

  // ==================== 通用文本 ====================
  
  /// 欢迎
  static const String welcome = 'welcome';
  
  /// 确认
  static const String confirm = 'confirm';
  
  /// 取消
  static const String cancel = 'cancel';
  
  /// 保存
  static const String save = 'save';
  
  /// 删除
  static const String delete = 'delete';
  
  /// 编辑
  static const String edit = 'edit';
  
  /// 搜索
  static const String search = 'search';
  
  /// 刷新
  static const String refresh = 'refresh';
  
  /// 加载中
  static const String loading = 'loading';
  
  /// 提交
  static const String submit = 'submit';

  // ==================== 设置相关 ====================
  
  /// 设置
  static const String settings = 'settings';
  
  /// 语言
  static const String language = 'language';
  
  /// 主题
  static const String theme = 'theme';
  
  /// 通知
  static const String notifications = 'notifications';
  
  /// 隐私
  static const String privacy = 'privacy';
  
  /// 关于
  static const String about = 'about';
  
  /// 选择语言
  static const String selectLanguage = 'selectLanguage';

  // ==================== 消息提示 ====================
  
  /// 成功
  static const String success = 'success';
  
  /// 错误
  static const String error = 'error';
  
  /// 警告
  static const String warning = 'warning';
  
  /// 信息
  static const String info = 'info';

  // ==================== 导航相关 ====================
  
  /// 首页
  static const String home = 'home';
  
  /// 个人中心
  static const String profile = 'profile';
  
  /// 返回
  static const String back = 'back';
  
  /// 下一步
  static const String next = 'next';
  
  /// 完成
  static const String done = 'done';

  // ==================== 数据相关 ====================
  
  /// 暂无数据
  static const String noData = 'noData';
  
  /// 加载失败
  static const String loadFailed = 'loadFailed';
  
  /// 重试
  static const String retry = 'retry';

  // ==================== 工具方法 ====================
  
  /// 获取所有翻译 key
  static List<String> get allKeys => [
        loginTitle,
        username,
        password,
        login,
        logout,
        register,
        forgotPassword,
        welcome,
        confirm,
        cancel,
        save,
        delete,
        edit,
        search,
        refresh,
        loading,
        submit,
        settings,
        language,
        theme,
        notifications,
        privacy,
        about,
        selectLanguage,
        success,
        error,
        warning,
        info,
        home,
        profile,
        back,
        next,
        done,
        noData,
        loadFailed,
        retry,
        welcomeToNiceAI,
        allInOneAIAssistant,
        continueWithGoogle,
        continueWithApple,
        continueWithFacebook,
        continueWithEmail,
        creatingNewAccount,
        termsConditions,
        privacyPolicy,
        willApply,
        and,
      ];
  
  /// 检查 key 是否存在
  static bool hasKey(String key) => allKeys.contains(key);
}

/// 扩展方法，提供更简洁的使用方式
extension AppStringsExtension on AppStrings {
  /// 获取翻译文本
  /// 
  /// 使用方式：
  /// ```dart
  /// AppStrings.loginTitle.text
  /// ```
  String get text => this.toString();
}
