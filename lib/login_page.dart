import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'effects_discover_page.dart';
import 'l10n/app_strings.dart';
import 'widgets/login_social_button.dart';
import 'l10n/translation_service.dart'; // 添加自定义翻译服务
import 'router/app_router.dart';
import 'utils/router_helper.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  final bool showCloseButton;

  const LoginPage({super.key, this.showCloseButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 背景装饰
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login/icon_login_top_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 关闭按钮
          if (showCloseButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

          // 主要内容
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/login/icon_login_logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // 欢迎文本
                Text(
                  AppStrings.welcomeToNiceAI.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.allInOneAIAssistant.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const Spacer(),

                // 社交登录按钮
                SocialLoginButton(
                  iconPath: 'assets/images/login/icon_login_google.png',
                  text: AppStrings.continueWithGoogle.tr,
                  onPressed: () {
                    // 谷歌登录跳转到发现主页面
                    RouterHelper.replaceAll(const DiscoverMainRoute());
                  },
                ),
                SocialLoginButton(
                  iconPath: 'assets/images/login/icon_login_apple.png',
                  text: AppStrings.continueWithApple.tr,
                  onPressed: () {
                    // 苹果登录跳转到 Podcast 页面
                    RouterHelper.replaceAll(const PodcastRoute());
                  },
                ),
                SocialLoginButton(
                  iconPath: 'assets/images/login/icon_login_facebook.png',
                  text: AppStrings.continueWithFacebook.tr,
                  onPressed: () {},
                ),
                SocialLoginButton(
                  iconPath: 'assets/images/login/icon_login_email.png',
                  text: AppStrings.continueWithEmail.tr,
                  onPressed: () {},
                ),

                const SizedBox(height: 40),

                // 用户协议提示
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.creatingNewAccount.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: AppStrings.termsConditions.tr,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: AppStrings.and.tr),
                            TextSpan(
                              text: AppStrings.privacyPolicy.tr,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: AppStrings.willApply.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
