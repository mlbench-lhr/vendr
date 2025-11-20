import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/styles/app_radiuses.dart';

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
        border: Border.all(color: Colors.white54, width: 2.w),
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
