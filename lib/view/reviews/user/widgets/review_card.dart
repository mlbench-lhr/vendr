import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/reviews/user/widgets/review_bar.dart';
import 'package:vendr/view/reviews/user/widgets/star_icons.dart';

class ReviewCard extends StatefulWidget {
  final IconData icon;
  final String rating;
  final String totalRating;

  final Color color;

  const ReviewCard({
    super.key,
    required this.icon,
    required this.color,
    required this.rating,
    required this.totalRating,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.w, left: 12.w, right: 12.w),
      height: 200.h,
      width: 200.w,
      decoration: BoxDecoration(
        color: const Color(0xff2E323D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewBar(
                  icon: Icons.star_rounded,
                  rating: '5',
                  color: Colors.amber,
                ),
                SizedBox(height: 10),
                ReviewBar(
                  icon: Icons.star_rounded,
                  rating: '4',
                  color: Colors.amber,
                ),
                SizedBox(height: 10),
                ReviewBar(
                  icon: Icons.star_rounded,
                  rating: '3',
                  color: Colors.amber,
                ),
                SizedBox(height: 10),
                ReviewBar(
                  icon: Icons.star_rounded,
                  rating: '2',
                  color: Colors.amber,
                ),
                SizedBox(height: 10),
                ReviewBar(
                  icon: Icons.star_rounded,
                  rating: '1',
                  color: Colors.amber,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.totalRating,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(icon: Icons.star_rounded, color: Colors.amber),
                    StarIcons(
                      icon: Icons.star_outline_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  '52 Reviews',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
