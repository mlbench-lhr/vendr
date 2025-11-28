import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/auth/widgets/language_menu.dart';
import 'package:vendr/view/auth/widgets/social_login_btn.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

bool hidePassword = true;
bool hideConfirmPassword = true;

class _UserSignupScreenState extends State<UserSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
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
            SizedBox(height: 36.h),
            Row(
              children: [
                Text(
                  'Welcome to Vendr',
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
              'We are happy to see here. Please fill all the following fields to create a new account.',
              style: context.typography.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 42.h),
            Text(
              'Name',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              hint: 'Enter your name',
              suffixIcon: Icon(Icons.person_2_outlined),
            ),

            SizedBox(height: 24.h),
            Text(
              'Email',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Icon(Icons.mail_outline),
            ),

            SizedBox(height: 24.h),
            Text(
              'Password',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              hint: 'Enter password',
              obscureText: hidePassword,
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
            SizedBox(height: 24.h),
            Text(
              'Confirm Password',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 6.h),
            MyTextField(
              hint: 'Enter password',
              obscureText: hideConfirmPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                child: Icon(
                  hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: 36.h),
            MyButton(
              label: 'Sign Up',
              onPressed: () {
                debugPrint('Login button pressed!');
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
                  'Sign Up With',
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
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have account?',
                  style: context.typography.bodySmall.copyWith(),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sign In',
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
