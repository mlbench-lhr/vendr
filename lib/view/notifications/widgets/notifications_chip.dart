import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class NotificationsChip extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  const NotificationsChip({
    super.key,
    this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.white70,
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: context.colors.primary,
            backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
            child: hasImage
                ? null // image will show automatically
                : Icon(Icons.home_outlined, color: Colors.white, size: 35.r),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.typography.label.copyWith(fontSize: 15.sp),
              ),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                description,
                style: context.typography.label.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
