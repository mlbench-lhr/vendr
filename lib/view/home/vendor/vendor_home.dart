import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_button.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/reviews_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  List<MenuItemModel> menuItems = [];
  List<SingleReviewModel> reviews = [];

  final sessionController = SessionController();
  @override
  void initState() {
    super.initState();
    sessionController.addListener(_onSessionChanged);
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    sessionController.removeListener(_onSessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //set vendor profile data from session
    final vendor = sessionController.vendor!;
    if (vendor.menu != null) {
      menuItems = vendor.menu!;
    }

    if (vendor.reviews != null) {
      reviews = vendor.reviews!.list;
    }

    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.w),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VendorAvatar(vendorProfileImage: vendor.profileImage),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          8.height,
                          Text(
                            vendor.name,
                            style: context.typography.title.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            vendor.vendorType,
                            style: context.typography.body.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          UserHomeService.gotoNotifications(
                            context,
                          ); //TODO: Change with VendorHomeService
                        },
                        child: NotificationsBtn(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  LocationSection(location: vendor.address),
                  SizedBox(height: 24.h),
                  //Menu heading
                  MenuHeading(productsCount: vendor.menu?.length ?? 0),
                ],
              ),
            ),
            //End: Menu heading
            //Menu Items
            _buildMenuItems(menuItems),
            //Vendor hours heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VendorHoursHeading(),
                  SizedBox(height: 16.h),
                  if (vendor.hours != null) ...[
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.w,
                      children: [
                        VendorHoursCard(
                          day: 'Monday',
                          startTime: vendor.hours!.days.monday.start,
                          endTime: vendor.hours!.days.monday.end,
                          isEnabled: vendor.hours!.days.monday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Tuesday',
                          // startTime: '09:00 AM',
                          // endTime: '06:00 PM',
                          startTime: vendor.hours!.days.tuesday.start,
                          endTime: vendor.hours!.days.tuesday.end,
                          isEnabled: vendor.hours!.days.tuesday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Wednesday',
                          startTime: vendor.hours!.days.wednesday.start,
                          endTime: vendor.hours!.days.wednesday.end,
                          isEnabled: vendor.hours!.days.wednesday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Thursday',
                          startTime: vendor.hours!.days.thursday.start,
                          endTime: vendor.hours!.days.thursday.end,
                          isEnabled: vendor.hours!.days.thursday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Friday',
                          startTime: vendor.hours!.days.friday.start,
                          endTime: vendor.hours!.days.friday.end,
                          isEnabled: vendor.hours!.days.friday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Saturday',
                          startTime: vendor.hours!.days.saturday.start,
                          endTime: vendor.hours!.days.saturday.end,
                          isEnabled: vendor.hours!.days.saturday.enabled,
                        ),
                        VendorHoursCard(
                          day: 'Sunday',
                          startTime: vendor.hours!.days.sunday.start,
                          endTime: vendor.hours!.days.sunday.end,
                          isEnabled: vendor.hours!.days.sunday.enabled,
                        ),
                      ],
                    ),
                  ] else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Working hours not added yet.',
                      ),
                    ),
                  SizedBox(height: 24.h),
                  ReviewsSectionHeading(),
                  SizedBox(height: 16.h),
                  //Reviews
                  _buildReviewsList(reviews),
                  if (reviews.isNotEmpty) SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(List<MenuItemModel> menuItems) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        menuItems.isNotEmpty
            ? SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 16.w),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: menuItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuItemTile(
                      name: menuItems[index].itemName,
                      price: menuItems[index].servings.first.servingPrice,
                      imageUrl: menuItems[index].imageUrl,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 16.w);
                  },
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  textAlign: TextAlign.center,
                  'No menu items found.',
                  // style: context.typography.body.copyWith(fontSize: 14.sp),
                ),
              ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

Widget _buildReviewsList(List<SingleReviewModel> reviews) {
  return reviews.isNotEmpty
      ? SizedBox(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviews.length,
            itemBuilder: (BuildContext context, int index) {
              return ReviewTile(
                // name: reviews[index]['name'],
                // rating: reviews[index]['rating'],
                // timeStamp: reviews[index]['time_stamp'],
                // content: reviews[index]['content'],
                name: reviews[index].user.name,
                rating: reviews[index].rating.toDouble(),
                imageUrl: reviews[index].user.profileImage,
                timeStamp: ReviewsService.formatTimeAgo(
                  reviews[index].createdAt,
                ),
                content: reviews[index].message,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 12.h);
            },
          ),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('No reviews found.'),
        );
}

class VendorHoursCard extends StatelessWidget {
  const VendorHoursCard({
    super.key,
    required this.day,
    this.startTime,
    this.endTime,
    this.isEnabled = false,
  });
  final String day;
  final String? startTime;
  final String? endTime;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white12 : Colors.red,
        borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
      ),
      height: 90.h,
      width: 104.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: context.typography.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          isEnabled
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.green,
                        ),
                        Container(
                          color: Colors.white60,
                          width: 2.5.w,
                          height: 16.h,
                        ),
                        CircleAvatar(radius: 4.r, backgroundColor: Colors.red),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          startTime ?? '',
                          style: context.typography.bodySmall.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          endTime ?? '',
                          style: context.typography.bodySmall.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  'Off',
                  style: context.typography.body.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}

class MenuHeading extends StatelessWidget {
  const MenuHeading({super.key, required this.productsCount});
  final int productsCount;
  @override
  Widget build(BuildContext context) {
    return
    //  productsCount > 0
    //     ?
    Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.receipt_outlined, color: Colors.white, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Text(
          'Menu',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        Text(
          '$productsCount Products',
          style: context.typography.body.copyWith(fontSize: 14.sp),
        ),
      ],
    );
    // : SizedBox.shrink();
  }
}

class VendorHoursHeading extends StatelessWidget {
  const VendorHoursHeading({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.alarm, color: Colors.white, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Text(
          'Vendor Hours',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        Text(
          // '8 Hours',
          VendorHomeService.getVendorWorkingHoursToday(),
          style: context.typography.body.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class ReviewsSectionHeading extends StatelessWidget {
  const ReviewsSectionHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.star_outline, color: Colors.white, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Text(
          'Reviews',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        MyTextButton(
          label: 'View All',
          isDark: true,
          fontSize: 14.sp,
          onPressed: () {
            VendorHomeService.gotoReviews(context, isVendor: true);
          },
        ),
      ],
    );
  }
}

class LocationSection extends StatelessWidget {
  const LocationSection({super.key, required this.location});
  final String? location;
  @override
  Widget build(BuildContext context) {
    return location != null
        ? Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white24,
                child: Icon(
                  // Icons.my_location_outlined,
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Location',
                      style: context.typography.title.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      overflow: TextOverflow.clip,
                      // '15 Maiden Ln Suite 908, New York, NY 10038, United States',
                      location!,
                      style: context.typography.body.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class VendorAvatar extends StatelessWidget {
  const VendorAvatar({super.key, this.vendorProfileImage});
  final String? vendorProfileImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VendorHomeService.gotoVendorProfile(context);
      },
      child: CircleAvatar(
        radius: 40.r,
        backgroundColor: Colors.white70,
        child: CircleAvatar(
          backgroundColor: context.colors.buttonPrimary,
          radius: 38.r,
          backgroundImage: vendorProfileImage != null
              ? NetworkImage(vendorProfileImage!)
              : null,
          child: vendorProfileImage != null
              ? null
              : Icon(Icons.person, color: Colors.white, size: 40.w),
        ),
      ),
    );
  }
}

class NotificationsBtn extends StatelessWidget {
  const NotificationsBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.white24,
      child: Icon(Icons.notifications_outlined, color: Colors.white),
    );
  }
}
