import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationChip extends StatelessWidget {
  const LocationChip({required this.label, required this.onDelete, super.key});
  final String label;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      // padding: EdgeInsets.only(left: 12.w, right: 12.w),
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_pin, color: Colors.white60, size: 20.w),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              style: typography.body.copyWith(
                color: colors.inputText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 28.w,
            height: 28.h,
            child: IconButton(
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
              // icon: Assets.icons.close.svg(),
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
