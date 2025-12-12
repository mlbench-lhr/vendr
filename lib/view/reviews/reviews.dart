import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/reviews_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';
import 'package:vendr/view/reviews/widgets/add_review_bottom_sheet.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.isVendor});
  final bool isVendor;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late Future<ReviewsModel?> _reviewsFuture;

  // Internal analyzed structure: { 'average': double, 'totalReviews': int, 'distribution': { '5.0': double, ... } }
  final Map<String, dynamic> _ratingAnalysis = {};

  @override
  void initState() {
    super.initState();
    debugPrint(' iS vendor: ${widget.isVendor}');
    _reviewsFuture = _fetchData();
  }

  Future<ReviewsModel?> _fetchData() async {
    try {
      final ReviewsModel? response = await VendorHomeService().getVendorReviews(
        context,
      );

      if (response == null) return null;

      // Build distribution (1..5) based on provided response.list
      final List<SingleReviewModel> reviewsList = response.list;

      final Map<int, int> counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final r in reviewsList) {
        final star = (r.rating < 1)
            ? 1
            : (r.rating > 5)
            ? 5
            : r.rating;
        counts[star] = (counts[star] ?? 0) + 1;
      }

      final int totalReviews = response.totalReviews;
      final Map<String, double> distribution = {
        for (var i = 5; i >= 1; i--) '$i.0': 0.0,
      };

      if (totalReviews > 0) {
        for (var i = 1; i <= 5; i++) {
          distribution['$i.0'] = (counts[i]! / totalReviews);
        }
      }

      final average = response.averageRating;

      _ratingAnalysis
        ..clear()
        ..addAll({
          'average': double.parse(average.toStringAsFixed(1)),
          'totalReviews': totalReviews,
          'distribution': distribution,
        });

      return response;
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return null;
    }
  }

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
        child: FutureBuilder<ReviewsModel?>(
          future: _reviewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget(color: Colors.white));
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _buildEmptyReviews(context);
            }

            final ReviewsModel data = snapshot.data!;
            final List<SingleReviewModel> reviews = data.list;

            if (reviews.isEmpty) {
              return _buildEmptyReviews(context);
            }

            return ListView(
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
                      _buildAverageRating(context),
                    ],
                  ),
                ),
                24.height,
                _buildReviewsList(reviews),
                if (!widget.isVendor) 100.height,
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: widget.isVendor
            ? const SizedBox.shrink()
            : MyButton(
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

  // build reviews list
  SizedBox _buildReviewsList(List<SingleReviewModel> reviews) {
    return SizedBox(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reviews.length,
        itemBuilder: (BuildContext context, int index) {
          final SingleReviewModel r = reviews[index];

          final name = r.user.name.isNotEmpty ? r.user.name : 'User';
          final rating = r.rating.toDouble();
          final timeStamp = ReviewsService.formatTimeAgo(r.createdAt);
          final content = r.message;

          return ReviewTile(
            name: name,
            rating: rating,
            timeStamp: timeStamp,
            content: content,
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

  Widget _buildAverageRating(BuildContext context) {
    final averageRating = _ratingAnalysis['average'] as double? ?? 0.0;
    final totalReviews = _ratingAnalysis['totalReviews'] as int? ?? 0;

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
            '$totalReviews Reviews',
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
