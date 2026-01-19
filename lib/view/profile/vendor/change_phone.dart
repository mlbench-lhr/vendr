import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_pinput.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';

class ChangePhoneNumberScreen extends StatefulWidget {
  const ChangePhoneNumberScreen({super.key});

  @override
  State<ChangePhoneNumberScreen> createState() =>
      _ChangePhoneNumberScreenState();
}

class _ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  final _pinputController = TextEditingController();
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Change Phone Number',
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
              'Just enter your new phone number so we can send you a verification code to continue.',
              style: context.typography.bodySmall.copyWith(),
            ),
            24.height,
            Text(
              'New Phone Number',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            10.height,
            MyTextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // Allows digits (0-9) and the plus sign (+)
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              hint: 'Enter new phone number',
              suffixIcon: Icon(Icons.phone_outlined),
              controller: _phoneController,
            ),

            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    //send otp
                  },
                  child: Text(
                    'Send OTP',
                    style: context.typography.body.copyWith(
                      color: context.colors.buttonPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            32.height,
            Center(child: MyPinput(controller: _pinputController)),

            const Spacer(),
            MyButton(
              label: 'Verify',
              onPressed: () {
                verifyPhoneOTP(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void verifyPhoneOTP(BuildContext context) {
    return context.flushBarSuccessMessage(
      message: 'Phone number updated successfully!',
    );
  }
}
