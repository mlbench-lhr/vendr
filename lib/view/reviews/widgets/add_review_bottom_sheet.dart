import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class AddReviewBottomSheet extends StatefulWidget {
  const AddReviewBottomSheet({super.key});

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  double rating = 0;
  final TextEditingController feedbackController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // Return a transparent scaffold so the background stays clear
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 120.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
              ),
            ),
          ),
          SizedBox(height: 24.w),
          Center(
            child: Text(
              'Give Feedback',
              style: context.typography.title.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Rate this Vendor',
            style: context.typography.title.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          RatingBar.builder(
            unratedColor: Colors.white,
            itemBuilder: (_, __) =>
                Icon(Icons.star_rounded, size: 17.w, color: Colors.amber),
            onRatingUpdate: (value) {
              setState(() => rating = value);
            },
          ),
          SizedBox(height: 25.h),
          Text(
            'Feedback',
            style: context.typography.label.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          MyTextField(maxLines: 5, controller: feedbackController),
          SizedBox(height: 40.w),
          MyButton(
            isLoading: isLoading,
            label: 'Add',
            onPressed: () {
              debugPrint('Reviews add press');
            },
          ),
        ],
      ),
    );
  }
}
