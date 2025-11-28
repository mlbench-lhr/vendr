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
          radius: 20.r,
          backgroundColor: Colors.white54,
          child: CircleAvatar(
            radius: 19.r,
            backgroundColor: context.colors.primary,
            backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
            child: hasImage
                ? null // image will show automatically
                : Icon(Icons.home_outlined, color: Colors.white, size: 35.r),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.typography.title.copyWith(fontSize: 16.sp),
              ),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                description,
                style: context.typography.label.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
