import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/services/common/auth_service.dart';

class ProfileTypeSelectionScreen extends StatefulWidget {
  const ProfileTypeSelectionScreen({super.key});

  @override
  State<ProfileTypeSelectionScreen> createState() =>
      _ProfileTypeSelectionScreenState();
}

class _ProfileTypeSelectionScreenState
    extends State<ProfileTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false, //don't show back button here
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Text(
              'Profile Type',
              style: context.typography.title.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Select your profile type according to your need.',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AccountTypeCard(
                    topMargin: 0,
                    bottomMargin: 100,
                    backgroundColor: context.colors.buttonPrimary,
                    isVendor: true,
                  ),
                  const Spacer(),
                  AccountTypeCard(
                    topMargin: 100,
                    bottomMargin: 0,
                    backgroundColor: context.colors.buttonDisabled,
                    isVendor: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTypeCard extends StatelessWidget {
  const AccountTypeCard({
    super.key,
    required this.topMargin,
    required this.bottomMargin,
    required this.backgroundColor,
    required this.isVendor,
  });
  final double topMargin;
  final double bottomMargin;
  final Color backgroundColor;
  final bool isVendor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AuthService.gotoLogin(context, isVendor);
      },
      child: Container(
        margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
          image: DecorationImage(
            image: AssetImage(Assets.images.blocksPattern.path),
            fit: BoxFit.cover,
          ),
        ),
        width: 160.w,
        height: 381.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isVendor
                ? Assets.icons.shop.svg(width: 48.w)
                : Assets.icons.profile.svg(width: 48.w),
            SizedBox(height: 24.h),
            Text(
              'I am',
              style: context.typography.body.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              isVendor ? 'Vendor' : 'User',
              style: context.typography.title.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
