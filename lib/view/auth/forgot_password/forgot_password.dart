import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_pinput.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/services/common/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.isVendor});
  final bool isVendor;
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;
  bool isSendingOtp = false;
  bool hasSentOtp = false;
  int remainingTime = 0;
  Timer? _timer;

  void _startTimer() {
    if (mounted) {
      setState(() {
        remainingTime = 60;
        hasSentOtp = true; // Moved here to ensure proper state after sending
      });
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() => remainingTime--);
        }
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    if (mounted) {
      setState(() => isSendingOtp = true);
    }

    final isSent = await AuthService().sendForgotOtp(
      context: context,
      // isDoctor: widget.isDoctor,
      email: emailController.text.trim(),
      isUser: !widget.isVendor,
    );
    if (isSent) {
      _startTimer();
    }
    if (mounted) {
      setState(() => isSendingOtp = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MyScaffold(
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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        style: context.typography.body.copyWith(
                          fontSize: 14.sp,
                        ),
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
                      MyFormTextField(
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        readOnly: isLoading,
                        suffixIcon: Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required.';
                          } else if (!value.emailValidator()) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: (isSendingOtp || remainingTime > 0)
                              ? null
                              : _sendOtp,
                          child: Text(
                            // 'Resend OTP',
                            hasSentOtp
                                ? (remainingTime > 0
                                      ? '${'Resend OTP'} in $remainingTime s'
                                      : 'Resend OTP')
                                : 'Send OTP',
                            style: context.typography.title.copyWith(
                              color: context.colors.buttonPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Center(child: MyPinput(controller: pinController)),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),

                  // child: MyButton(
                  //   label: 'Submit',
                  //   onPressed: () {
                  //     AuthService.gotoNewPassword(context);
                  //   },
                  // ),
                  child: MyButton(
                    label: 'Submit',
                    isLoading: isLoading,
                    onPressed:
                        pinController.text.length < 4 ||
                            emailController.text.trim().isEmpty
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            if (mounted) {
                              setState(() => isLoading = true);
                            }
                            await AuthService().verifyForgotOtp(
                              context: context,
                              // isDoctor: widget.isDoctor,
                              email: emailController.text.trim(),
                              otp: pinController.text,
                            );
                            if (mounted) {
                              setState(() => isLoading = false);
                            }
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
