import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/view/reviews/widgets/add_review_bottom_sheet.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.isVendor});
  final bool isVendor;
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  //Sample rating analysis
  final Map<String, dynamic> _ratingAnalysis = {
    "averageRating": 3.2,
    "totalReviews": 120,

    // distribution keys must be like "1.0", "2.0", ..., "5.0"
    "distribution": {
      "5.0": 0.60, // 60% gave 5 stars
      "4.0": 0.20, // 20%
      "3.0": 0.10, // 10%
      "2.0": 0.05, // 5%
      "1.0": 0.05, // 5%
    },
  };
  List<Map<String, dynamic>> reviews = [
    {
      'id': 1,
      'name': 'Cameron Williamson',
      'rating': 4.0,
      'time_stamp': '2 mins ago',
      'content':
          'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 2,
      'name': 'Jane Cooper',
      'rating': 2.5,
      'time_stamp': '4 hours ago',
      'content':
          'Velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 3,
      'name': 'James Smith',
      'rating': 5.0,
      'time_stamp': '1 day ago',
      'content': 'Adipisicing qui sunt do rependerit ad laborum.',
    },
    {
      'id': 1,
      'name': 'Cameron Williamson',
      'rating': 4.0,
      'time_stamp': '2 mins ago',
      'content':
          'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 2,
      'name': 'Jane Cooper',
      'rating': 2.5,
      'time_stamp': '4 hours ago',
      'content':
          'Velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 3,
      'name': 'James Smith',
      'rating': 5.0,
      'time_stamp': '1 day ago',
      'content': 'Adipisicing qui sunt do rependerit ad laborum.',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.w, right: 16.w, left: 16.w),
        child: Center(
          child: Stack(
            children: [
              reviews.isNotEmpty
                  ? ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 8.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(
                              AppRadiuses.mediumRadius,
                            ),
                            border: Border.all(color: Colors.white38),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRatingDistribution(context),
                              _buildAverageRating(
                                context,
                                //  reviewsResponse,
                              ),
                            ],
                          ),
                        ),
                        24.height,
                        _buildReviewsList(reviews),
                        if (!widget.isVendor) 100.height,
                      ],
                    )
                  : _buildEmptyReviews(context),
              if (!widget.isVendor)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton(
                      onPressed: () {
                        MyBottomSheet.show(
                          context,
                          isDismissible: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: context.colors.primary,
                          child: AddReviewBottomSheet(),
                        );
                      },
                      label: 'Write Review',
                    ),
                    24.height,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyReviews(BuildContext context) {
    return Center(
      child: Column(
        children: [
          180.height,
          Image.asset(Assets.images.disconnected.path),
          24.height,
          Text(
            'No reviews added yet!',
            style: context.typography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  //build reviews list
  SizedBox _buildReviewsList(List<Map<String, dynamic>> reviews) {
    return SizedBox(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reviews.length,
        itemBuilder: (BuildContext context, int index) {
          return ReviewTile(
            name: reviews[index]['name'],
            rating: reviews[index]['rating'],
            timeStamp: reviews[index]['time_stamp'],
            content: reviews[index]['content'],
            // imageUrl: ,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(thickness: 1.5.h),
          );
        },
      ),
    );
  }

  Widget _buildAverageRating(
    BuildContext context,
    // ReviewResponse reviewsResponse,
  ) {
    // final averageRating = _ratingAnalysis['average'] as double? ?? 0.0;
    final averageRating = _ratingAnalysis['averageRating'] as double? ?? 0.0;

    return Padding(
      padding: EdgeInsets.only(left: 0.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: context.typography.title.copyWith(
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.cardPrimary,
            ),
          ),
          RatingBarIndicator(
            itemPadding: EdgeInsets.only(right: 2.w),
            rating: averageRating,
            itemSize: 17.w,
            itemBuilder: (context, _) =>
                const Icon(Icons.star_rounded, color: Colors.amber),
          ),
          SizedBox(height: 12.h),
          Text(
            // reviewsResponse.totalReviews == null
            //     ? context.l10n.reviews_zero
            //     :
            // context.l10n.reviews_count(reviewsResponse.totalReviews.toString(),
            // ),
            '0 Reviews',
            style: context.typography.subtitle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(BuildContext context) {
    final distribution =
        _ratingAnalysis['distribution'] as Map<String, dynamic>? ?? {};

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 5; i >= 1; i--)
          Padding(
            padding: EdgeInsets.only(bottom: i > 1 ? 10.h : 0),
            child: _buildRatingBar(
              context,
              i,
              distribution['$i.0'] as double? ?? 0.0,
            ),
          ),
      ],
    );
  }

  Widget _buildRatingBar(BuildContext context, int star, double percentage) {
    return Row(
      children: [
        Text(
          '$star',
          style: context.typography.subtitle.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.cardSecondary,
          ),
        ),
        SizedBox(width: 5.w),
        Icon(Icons.star_rounded, size: 16.w, color: Colors.amber),
        LinearPercentIndicator(
          barRadius: Radius.circular(120.r),
          width: 170.w,
          lineHeight: 7.5.h,
          percent: percentage,
          backgroundColor: Colors.white24,
          progressColor: context.colors.buttonPrimary,
        ),
      ],
    );
  }
}
