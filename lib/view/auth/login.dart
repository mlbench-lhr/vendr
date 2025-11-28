import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/view/auth/widgets/language_menu.dart';
import 'package:vendr/view/auth/widgets/social_login_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.isVendor});
  final bool isVendor;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  'Vendr',
                  style: context.typography.title.copyWith(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                LanguageMenu(
                  selectedLanguage: Language('en', 'Eng'),
                  onSelected: (lang) {
                    debugPrint('Selected Language: $lang');
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Text(
                  'Welcome back',
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                  ),
                ),
                // Container(
                //   color: Colors.green,
                //   child: Assets.icons.wavingHand.svg(),
                // ),
                SizedBox(width: 6.w),
                Icon(Icons.waving_hand, color: Colors.amber),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'We are happy to see you again. To use your account, you should log in first.',
              style: context.typography.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Email',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              suffixIcon: Icon(Icons.mail_outline),
              hint: 'Enter your email',
            ),

            SizedBox(height: 24.h),
            Text(
              'Password',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              obscureText: hidePassword,
              hint: 'Enter your password',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                child: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    AuthService.gotoForgotPassword(context);
                  },
                  child: Text(
                    'Forgot password?',
                    style: context.typography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: context.colors.buttonPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            MyButton(
              label: 'Log In',
              onPressed: () {
                widget.isVendor
                    ? AuthService.gotoVendorHome(context)
                    : AuthService.gotoUserHome(context);
              },
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Container(color: Colors.white70, height: 1.5.h),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Log In With',
                  style: context.typography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(color: Colors.white70, height: 1.5.h),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SocialLoginBtn(
                  type: 'apple',
                  onTap: () {
                    debugPrint('apple btn pressed');
                  },
                ),
                SocialLoginBtn(
                  type: 'google',
                  onTap: () {
                    debugPrint('google btn pressed');
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account?",
                  style: context.typography.bodySmall.copyWith(),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    AuthService.gotoSignup(context, widget.isVendor);
                  },
                  child: Text(
                    'Sign Up',
                    style: context.typography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.buttonPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
