import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_pinput.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Vendr',
          style: context.typography.title.copyWith(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 36.h),
            Text(
              'Forgot Password?',
              style: context.typography.title.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Nothing to worry. Just enter your email address so we can send you a verification code to continue.',
              style: context.typography.body.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 36.h),
            Text(
              'Email',
              style: context.typography.title.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            MyTextField(
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Icon(Icons.email_outlined),
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Resend OTP',
                  style: context.typography.title.copyWith(
                    color: context.colors.buttonPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Center(child: MyPinput(controller: pinController)),
            const Spacer(),
            MyButton(
              label: 'Submit',
              onPressed: () {
                AuthService.gotoNewPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
