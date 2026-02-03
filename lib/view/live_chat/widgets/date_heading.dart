import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class DateHeading extends StatelessWidget {
  const DateHeading({required this.date, super.key});
  final String date;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125.w,
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  colors: [Colors.white, context.colors.textSecondary],
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              date,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 5.w),
            Container(
              width: 125.w,
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.center,
                  colors: [Colors.white, context.colors.textSecondary],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25.h),
      ],
    );
  }
}
