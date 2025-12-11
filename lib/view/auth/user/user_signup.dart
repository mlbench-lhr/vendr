import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/view/auth/widgets/language_menu.dart';
import 'package:vendr/view/auth/widgets/social_login_btn.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fillFormForTesting();
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    isFormFilled.dispose();

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFilled =
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty;
    isFormFilled.value = isFilled;
  }

  ///
  ///
  ///Auto Fill fields in debug mode only
  ///
  ///
  void fillFormForTesting() {
    if (kDebugMode) {
      _nameController.text = 'Test User';
      _emailController.text = 'mtalha2410+USER2dec2@gmail.com';
      _passwordController.text = '12345678';
      _confirmPasswordController.text = '12345678';
      isFormFilled.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: formKey,
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
              MyFormTextField(
                hint: 'Enter your name',
                suffixIcon: Icon(Icons.person_2_outlined),
                controller: _nameController,
                readOnly: isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required.';
                  } else if (!value.nameValidator()) {
                    return 'Name must contain only alphabets and spaces.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),
              Text(
                'Email',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 6.h),
              MyFormTextField(
                textCapitalization: TextCapitalization.none,
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icon(Icons.mail_outline),
                controller: _emailController,
                readOnly: isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  } else if (!value.emailValidator()) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),
              Text(
                'Password',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 6.h),
              MyFormTextField(
                hint: 'Enter password',
                obscureText: hidePassword,
                controller: _passwordController,
                readOnly: isLoading,
                focusNode: _passwordFocusNode,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required.';
                  } else if (!value.lessSecurePasswordValidator()) {
                    return 'Password must contain 8 characters and at least one uppercase letter, one number, and one special character.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'Confirm Password',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 6.h),
              MyFormTextField(
                hint: 'Enter password',
                controller: _confirmPasswordController,
                obscureText: hideConfirmPassword,
                readOnly: isLoading,
                focusNode: _confirmPasswordFocusNode,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      hideConfirmPassword = !hideConfirmPassword;
                    });
                  },
                  child: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is required.';
                  } else if (value != _passwordController.text) {
                    return 'Confirm Password does not match Password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 36.h),
              ValueListenableBuilder<bool>(
                valueListenable: isFormFilled,
                builder: (_, isFilled, __) {
                  return MyButton(
                    label: 'Sign Up',
                    isLoading: isLoading,
                    onPressed: isFilled && !isLoading
                        ? () async {
                            if (!formKey.currentState!.validate()) return;
                            setState(() => isLoading = true);
                            await AuthService()
                                .userSignup(
                                  context: context,
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                )
                                .then((_) {
                                  if (mounted) {
                                    setState(() => isLoading = false);
                                  }
                                });
                          }
                        : null,
                  );
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
      ),
    );
  }
}
