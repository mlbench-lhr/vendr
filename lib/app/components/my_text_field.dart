import 'package:flutter/services.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    this.hint,
    this.label = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.errorText,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.borderRadius = 16,
    this.onChanged,
    this.maxLines,
    this.onSubmitted,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final int? maxLength;
  final double borderRadius;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      controller: controller,
      cursorColor: context.colors.inputIcon,
      cursorErrorColor: context.colors.error,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      textAlign: textAlign,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: !label ? hint : null,
        labelText: label ? hint : null,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: suffixIcon,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.colors.inputBorder.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(borderRadius.sp),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.colors.inputBorder.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(borderRadius.sp),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.colors.error),
          borderRadius: BorderRadius.circular(borderRadius.sp),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.colors.error),
          borderRadius: BorderRadius.circular(borderRadius.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.colors.inputBorder.withValues(),
          ),
          borderRadius: BorderRadius.circular(borderRadius.sp),
        ),
      ),
    );
  }
}
