import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class ReviewBar extends StatelessWidget {
  final IconData icon;
  final String rating;
  final Color color;

  const ReviewBar({
    super.key,
    required this.icon,
    required this.rating,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // parse rating string to double and clamp between 0 and 5
    final double ratingValue = (double.tryParse(rating) ?? 0.0).clamp(0.0, 5.0);

    return Row(
      children: [
        Text(
          rating,
          style: context.typography.label.copyWith(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(width: 7.w),

        // use passed icon and color
        Icon(icon, color: color, size: 20.sp),

        SizedBox(width: 10.w),

        // progress bar takes remaining width
        Flexible(
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratingValue / 5.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
