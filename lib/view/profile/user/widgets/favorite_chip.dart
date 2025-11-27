import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class FavoriteChip extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String venderType;
  const FavoriteChip({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.venderType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: context.colors.buttonPrimary,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 23.r,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: context.typography.label.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              venderType,
              style: context.typography.label.copyWith(fontSize: 13.sp),
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.star_rounded, size: 24.w, color: Colors.white),
        ),
      ],
    );
  }
}
