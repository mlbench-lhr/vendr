import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_pinput.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _pinputController = TextEditingController();
  final _emailController = TextEditingController();
  bool isSubmitted = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Change Email',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSubmitted
                  ? 'Enter your new email address below.'
                  : 'Just enter your old email address so we can send you a verification code to continue.',
              style: context.typography.bodySmall.copyWith(),
            ),
            24.height,
            Text(
              isSubmitted ? 'New Email Address' : 'Email Address',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            10.height,
            MyTextField(
              hint: 'Enter your email',
              suffixIcon: Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),

            if (!isSubmitted) ...[
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Resend OTP',
                    style: context.typography.body.copyWith(
                      color: context.colors.buttonPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              32.height,
              Center(child: MyPinput(controller: _pinputController)),
            ],
            const Spacer(),
            MyButton(
              label: isSubmitted ? 'Update' : 'Submit',
              onPressed: () {
                if (isLoading) return;
                if (!isSubmitted) {
                  setState(() {
                    isSubmitted = true;
                  });
                  _emailController.clear();
                } else {
                  context.flushBarSuccessMessage(
                    message: 'Email address updated successfully!',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
