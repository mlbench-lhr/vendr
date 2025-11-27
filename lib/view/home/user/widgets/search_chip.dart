import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class SearchChip extends StatelessWidget {
  final String label;
  const SearchChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.typography.label.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios, size: 18),
      ],
    );
  }
}
