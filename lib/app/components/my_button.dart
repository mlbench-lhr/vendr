import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.label,
    super.key,
    this.onPressed,
    this.isDark = true,
    this.icon,
    this.isLoading = false,
    this.fontSize = 18,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isDark;
  final Widget? icon;
  final bool isLoading;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    final backgroundColor = isDark
        ? (isEnabled
              ? context.colors.buttonPrimary
              : context.colors.buttonDisabled)
        : (isEnabled
              ? context.colors.buttonSecondary
              : context.colors.buttonDisabled);

    final foregroundColor = isDark
        ? (isEnabled ? context.colors.buttonPrimaryText : Colors.black26)
        : (isEnabled ? Colors.black26 : context.colors.buttonDisabled);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, 56.h),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          // side: border,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
          ),
        ),
        icon: isLoading ? null : icon,
        label: isLoading
            ? LoadingWidget(
                size: 24.sp,
                // color: context.colors.primary,
                color: Colors.white54,
              )
            : Text(
                label,
                style: context.typography.button.copyWith(
                  color: foregroundColor,
                  fontSize: fontSize.sp,
                ),
              ),
      ),
    );
  }
}
