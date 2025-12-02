import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/l10n/l10n.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final pinController = TextEditingController();
  bool hideOldPassword = true;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.auth_change_password,
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            SizedBox(height: 36.h),
            Text(
              'Old Password',
              style: context.typography.title.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            MyTextField(
              hint: 'Enter password',
              obscureText: hideOldPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    hideOldPassword = !hideOldPassword;
                  });
                },
                child: Icon(
                  hideOldPassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'New Password',
              style: context.typography.title.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            MyTextField(
              obscureText: hidePassword,
              hint: 'Enter password',
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
              'Retype New Password',
              style: context.typography.title.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
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
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 32.w),
        child: MyButton(
          label: 'Submit',
          onPressed: () {
            debugPrint('Submit button pressed');
          },
        ),
      ),
    );
  }
}
