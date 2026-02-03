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
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';
import 'package:vendr/view/reviews/widgets/add_review_bottom_sheet.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.isVendor, this.vendorId});

  final bool isVendor;
  final String? vendorId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<SingleReviewModel> _reviews = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;

  int _page = 1;
  final int _limit = 50;

  /// { average, totalReviews, distribution }
  final Map<String, dynamic> _ratingAnalysis = {};

  @override
  void initState() {
    super.initState();
    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        _fetchData();
      }
    });
  }

  // ============================
  // FETCH + PAGINATION (MERGED)
  // ============================
  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) return;
    debugPrint("F E T C H  D A T A  C A L L E D");
    setState(() => _isLoading = true);

    ReviewsModel? response;

    try {
      if (widget.isVendor) {
        response = await VendorHomeService().getVendorReviews(
          context: context,
          page: _page,
          limit: _limit,
        );
      } else {
        response = await UserHomeService().getVendorReviews(
          context,
          vendorId: widget.vendorId!,
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (!mounted) return;

    if (response != null && response.list.isNotEmpty) {
      setState(() {
        _reviews.addAll(response!.list);
        _page++;
        _hasMore = response.list.length == _limit;
        _updateRatingAnalysis();
      });
    } else {
      _hasMore = false;
    }

    setState(() => _isLoading = false);
  }

  // ============================
  // RATING ANALYSIS (MERGED)
  // ============================
  void _updateRatingAnalysis() {
    final Map<int, int> counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (final r in _reviews) {
      final star = r.rating.clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }

    final int totalReviews = _reviews.length;

    final Map<String, double> distribution = {
      for (int i = 5; i >= 1; i--) '$i.0': 0.0,
    };

    if (totalReviews > 0) {
      for (int i = 1; i <= 5; i++) {
        distribution['$i.0'] = counts[i]! / totalReviews;
      }
    }

    final double average = totalReviews > 0
        ? _reviews.map((e) => e.rating).reduce((a, b) => a + b) / totalReviews
        : 0.0;

    _ratingAnalysis
      ..clear()
      ..addAll({
        'average': double.parse(average.toStringAsFixed(1)),
        'totalReviews': totalReviews,
        'distribution': distribution,
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ============================
  // UI
  // ============================
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _reviews.isEmpty && _isLoading
            ? const Center(child: LoadingWidget(color: Colors.white))
            : _reviews.isEmpty
            ? _buildEmptyReviews(context)
            : ListView(
                controller: _scrollController,
                children: [
                  16.height,
                  _buildHeader(context),
                  24.height,
                  _buildReviewsList(),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  // if (!_hasMore)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 20),
                  //     child: Center(
                  //       child: Text(
                  //         'No more reviews',
                  //         style: context.typography.subtitle.copyWith(
                  //           color: context.colors.textOnDark,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  if (!widget.isVendor) 100.height,
                ],
              ),
      ),
      bottomNavigationBar:
          // widget.isVendor ?
          const SizedBox.shrink(),
      // : Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      //     child: MyButton(
      //       label: 'Write Review',
      //       onPressed: () async {
      //         await MyBottomSheet.show(
      //           context,
      //           isDismissible: true,
      //           isScrollControlled: true,
      //           enableDrag: true,
      //           backgroundColor: context.colors.primary,
      //           child: AddReviewBottomSheet(
      //             vendorId: widget.vendorId!,
      //             parentContext: context,
      //             onSuccess: _fetchData,
      //           ),
      //         );
      //       },
      //     ),
      //   ),
    );
  }

  // ============================
  // WIDGETS
  // ============================
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRatingDistribution(context),
          _buildAverageRating(context),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final r = _reviews[index];
        return ReviewTile(
          isExpandable: true,
          name: r.user.name,
          rating: r.rating.toDouble(),
          timeStamp: ReviewsService.formatTimeAgo(r.createdAt),
          content: r.message,
        );
      },
      separatorBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Divider(thickness: 1.5.h),
      ),
    );
  }

  Widget _buildAverageRating(BuildContext context) {
    final average = _ratingAnalysis['average'] ?? 0.0;
    final total = _ratingAnalysis['totalReviews'] ?? 0;

    return Column(
      children: [
        Text(
          average.toString(),
          style: context.typography.title.copyWith(
            fontSize: 40.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.cardPrimary,
          ),
        ),
        RatingBarIndicator(
          rating: average,
          itemSize: 17.w,
          itemBuilder: (_, __) =>
              const Icon(Icons.star_rounded, color: Colors.amber),
        ),
        12.height,
        Text('$total Reviews'),
      ],
    );
  }

  Widget _buildRatingDistribution(BuildContext context) {
    final distribution =
        _ratingAnalysis['distribution'] as Map<String, double>? ?? {};

    return Column(
      children: List.generate(5, (index) {
        final star = 5 - index;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildRatingBar(context, star, distribution['$star.0'] ?? 0.0),
        );
      }),
    );
  }

  Widget _buildRatingBar(BuildContext context, int star, double percentage) {
    return Row(
      children: [
        Text('$star'),
        const Icon(Icons.star_rounded, color: Colors.amber),
        LinearPercentIndicator(
          width: 170.w,
          lineHeight: 7.5.h,
          percent: percentage,
          backgroundColor: Colors.white24,
          progressColor: context.colors.buttonPrimary,
        ),
      ],
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
}
