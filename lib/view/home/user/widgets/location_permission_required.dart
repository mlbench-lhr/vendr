import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';

class LocationPermissionRequired extends StatelessWidget {
  const LocationPermissionRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 435.h,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Color(0xFF2E323D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 6,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Image(
              image: AssetImage(Assets.images.locationPermissionRequired.path),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Turn",
                  style: context.typography.title.copyWith(
                    color: Colors.blue,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "Your Location On",
                  style: context.typography.title.copyWith(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              textAlign: TextAlign.center,
              "You'll be able to find yourself on the map, and you can access the app better after turing on the location access.",
              style: context.typography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            MyButton(
              label: 'Go To Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}
