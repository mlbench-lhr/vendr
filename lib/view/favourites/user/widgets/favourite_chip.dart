import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class FavouriteChip extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String venderType;
  const FavouriteChip({
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
          backgroundColor: Colors.white70,
          child: CircleAvatar(
            backgroundColor: context.colors.primary,
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
                fontSize: 17.sp,
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
          child: Icon(Icons.star_rounded, size: 30.w, color: Colors.white),
        ),
      ],
    );
  }
}
