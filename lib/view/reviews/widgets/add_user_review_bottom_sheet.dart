import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/data/exception/app_exceptions.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';

/// Bottom sheet for vendors to rate users after a meetup (stars only)
class AddUserReviewBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final VoidCallback onSuccess;
  final String userId;

  const AddUserReviewBottomSheet({
    super.key,
    required this.userId,
    required this.parentContext,
    required this.onSuccess,
  });

  @override
  State<AddUserReviewBottomSheet> createState() =>
      _AddUserReviewBottomSheetState();
}

class _AddUserReviewBottomSheetState extends State<AddUserReviewBottomSheet> {
  double rating = 0;
  bool isLoading = false;

  Future<void> _submitReview() async {
    if (isLoading) return;

    if (rating == 0) {
      context.flushBarErrorMessage(message: 'Please provide a rating');
      return;
    }

    setState(() => isLoading = true);

    try {
      final bool success = await VendorHomeService().submitUserReview(
        message: '', // Empty message since we only collect stars
        userId: widget.userId,
        rating: rating.toInt(),
        context: context,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!success) {
          return;
        }
        widget.onSuccess.call();
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop(true);
        if (!widget.parentContext.mounted) return;
        widget.parentContext.flushBarSuccessMessage(
          message: 'Rating added successfully',
        );
      });
    } on AppException catch (e) {
      if (!mounted) return;
      context.flushBarErrorMessage(message: e.userMessage);
    } catch (_) {
      if (!mounted) return;
      context.flushBarErrorMessage(message: 'Something went wrong');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            'Rate this User',
            style: context.typography.title.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          RatingBar.builder(
            unratedColor: Colors.white,
            itemBuilder: (_, _) =>
                Icon(Icons.star_rounded, size: 17.w, color: Colors.amber),
            onRatingUpdate: (value) {
              setState(() => rating = value);
            },
          ),
          SizedBox(height: 32.w),
          MyButton(
            isLoading: isLoading,
            label: 'Submit Rating',
            onPressed: () async {
              await _submitReview();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
