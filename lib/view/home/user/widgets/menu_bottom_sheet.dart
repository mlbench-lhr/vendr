import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/view/home/user/widgets/serving_counter.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      height: 500.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
            ),
          ),
          SizedBox(height: 16.w),
          //Category
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            'Sandwiches or Wraps',
                            style: context.typography.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(
                            width: 250.w,
                            child: Text(
                              textAlign: TextAlign.left,
                              'Spicy Chicken Wrap',
                              style: context.typography.body.copyWith(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        textAlign: TextAlign.left,
                        '\$24.00',
                        style: context.typography.body.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ServingCounter(), MenuDetailsImage()],
                ),
                12.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: context.typography.title.copyWith(),
                      ),
                      12.height,
                      Text(
                        'Enjoy a mouthwatering Spicy Chicken Wrap that combines tender chicken breast, fresh vegetables, and zesty sauce, all wrapped in a warm tortilla. This delightful wrap offers a perfect balance of flavors, with a kick of spice that will tantalize your taste buds.',
                        style: context.typography.bodySmall.copyWith(),
                      ),
                      16.height,
                    ],
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

class MenuDetailsImage extends StatelessWidget {
  const MenuDetailsImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadiuses.hundredRadius),
        ),
        border: Border.all(color: Colors.white12, width: 1.w),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            //TODO: image will be dynamic
            'https://img-global.cpcdn.com/recipes/ca64e4220565f1b8/680x781cq80/ekuru-white-moi-moi-recipe-main-photo.jpg',
          ),
        ),
      ),
    );
  }
}
