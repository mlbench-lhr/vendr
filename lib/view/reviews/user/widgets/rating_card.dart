import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/reviews/user/widgets/star_icons.dart';

class RatingCard extends StatelessWidget {
  final String imageUrl;
  final String reviewText;
  const RatingCard({
    super.key,
    required this.imageUrl,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.r,
              child: CircleAvatar(
                backgroundColor: context.colors.primary,
                radius: 28.r,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Courtney Henry',
                  style: context.typography.label.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    SizedBox(width: 15),
                    Text(
                      '2 mints ago',
                      style: context.typography.label.copyWith(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 17.h),
        Text(
          maxLines: 3,
          reviewText,
          style: context.typography.label.copyWith(fontSize: 13.5.sp),
        ),
      ],
    );
  }
}
