import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class LanguageChip extends StatelessWidget {
  final String languageName;
  final IconData? icon;
  const LanguageChip({super.key, required this.languageName, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          languageName,
          style: context.typography.label.copyWith(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (icon != null) Icon(icon),
      ],
    );
  }
}
