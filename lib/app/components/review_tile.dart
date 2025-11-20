import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    super.key,
    required this.name,
    required this.rating,
    required this.timeStamp,
    required this.content,
    this.imageUrl,
  });
  final String name;
  final double rating;
  final String timeStamp;
  final String content;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              //image
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.white60,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl as String)
                    : null,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //name
                  Text(name, style: context.typography.title.copyWith()),
                  //stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        itemPadding: EdgeInsets.only(right: 3.w),
                        rating: rating,
                        itemSize: 17.w,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                      ),
                      Text(timeStamp),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: context.typography.body.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
