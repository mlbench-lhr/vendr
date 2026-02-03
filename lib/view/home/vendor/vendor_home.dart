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
import 'package:vendr/services/common/location_service.dart';
import 'package:vendr/services/common/push_notifications_service.dart';
import 'package:vendr/services/common/reviews_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/home/vendor/widgets/custom_badge.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  List<MenuItemModel> menuItems = [];
  List<SingleReviewModel> reviews = [];
  bool _hasPermit = false;

  final sessionController = SessionController();
  final _locationService = VendorLocationService();

  void _loadDataFromSession() {
    final vendor = sessionController.vendor;
    if (vendor != null) {
      setState(() {
        _hasPermit = vendor.hasPermit ?? false;
        debugPrint('✅ _loadDataFromSession - Vendor: ${vendor.name}');
        debugPrint('✅ _loadDataFromSession - hasPermit: $_hasPermit');
        debugPrint(
          '✅ _loadDataFromSession - Raw permit value: ${vendor.hasPermit}',
        );
      });
    } else {
      debugPrint('⚠️ _loadDataFromSession - Vendor is null!');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromSession();
    sessionController.addListener(_onSessionChanged);
    PushNotificationsService().initFCM(context: context);
    _autoStartLocationSharing();
  }

  void _onSessionChanged() {
    if (mounted) {
      final vendor = sessionController.vendor;
      if (vendor != null) {
        final newPermitValue = vendor.hasPermit ?? false;
        debugPrint('🔄 Session changed - Previous hasPermit: $_hasPermit');
        debugPrint('🔄 Session changed - New hasPermit: $newPermitValue');
        debugPrint(
          '🔄 Session changed - Raw permit value: ${vendor.hasPermit}',
        );

        setState(() {
          _hasPermit = newPermitValue;
        });
      } else {
        debugPrint('⚠️ _onSessionChanged - Vendor is null!');
      }
    }
  }

  @override
  void dispose() {
    sessionController.removeListener(_onSessionChanged);
    VendorLocationService().stopSharing();
    super.dispose();
  }

  Future<void> _autoStartLocationSharing() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (!_locationService.isSharing) {
      try {
        await _locationService.startSharing();
        debugPrint('✅ Auto-started location sharing');
        if (mounted) setState(() {});
      } catch (e) {
        debugPrint('⚠️ Auto-start failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = sessionController.vendor;

    if (vendor == null) {
      return MyScaffold(
        body: Center(
          child: Text('Loading...', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // Update local state from session controller on every build
    // This ensures UI is always in sync
    if (_hasPermit != (vendor.hasPermit ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasPermit = vendor.hasPermit ?? false;
            debugPrint('🔄 Build sync - Updated hasPermit to: $_hasPermit');
          });
        }
      });
    }

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
                      VendorAvatar(
                        vendorProfileImage: vendor.profileImage,
                        // Use value directly from vendor, not from state
                        hasPermit: vendor.hasPermit ?? false,
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            8.height,
                            Text(
                              vendor.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          VendorHomeService.gotoChat(context);
                        },
                        child: ChatButton(),
                      ),
                    ],
                  ),

                  LocationSection(location: vendor.address),
                  SizedBox(height: 24.h),
                  MenuHeading(productsCount: vendor.menu?.length ?? 0),
                ],
              ),
            ),
            _buildMenuItems(menuItems),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VendorHoursHeading(),
                  SizedBox(height: 16.h),
                  if (vendor.hours != null) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(
                          AppRadiuses.mediumRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          VendorHoursRow(
                            day: 'Monday',
                            startTime: vendor.hours!.days.monday.start,
                            endTime: vendor.hours!.days.monday.end,
                            isEnabled: vendor.hours!.days.monday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Tuesday',
                            startTime: vendor.hours!.days.tuesday.start,
                            endTime: vendor.hours!.days.tuesday.end,
                            isEnabled: vendor.hours!.days.tuesday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Wednesday',
                            startTime: vendor.hours!.days.wednesday.start,
                            endTime: vendor.hours!.days.wednesday.end,
                            isEnabled: vendor.hours!.days.wednesday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Thursday',
                            startTime: vendor.hours!.days.thursday.start,
                            endTime: vendor.hours!.days.thursday.end,
                            isEnabled: vendor.hours!.days.thursday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Friday',
                            startTime: vendor.hours!.days.friday.start,
                            endTime: vendor.hours!.days.friday.end,
                            isEnabled: vendor.hours!.days.friday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Saturday',
                            startTime: vendor.hours!.days.saturday.start,
                            endTime: vendor.hours!.days.saturday.end,
                            isEnabled: vendor.hours!.days.saturday.enabled,
                          ),
                          VendorHoursRow(
                            day: 'Sunday',
                            startTime: vendor.hours!.days.sunday.start,
                            endTime: vendor.hours!.days.sunday.end,
                            isEnabled: vendor.hours!.days.sunday.enabled,
                          ),
                        ],
                      ),
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
    final reversedmenuItems = menuItems.reversed.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        reversedmenuItems.isNotEmpty
            ? SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 16.w),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: reversedmenuItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuItemTile(
                      onTap: () {
                        VendorProfileService.gotoAddEditProduct(
                          context,
                          true,
                          reversedmenuItems[index],
                        );
                      },
                      name: reversedmenuItems[index].itemName,
                      price:
                          reversedmenuItems[index].servings.first.servingPrice,
                      imageUrl: reversedmenuItems[index].imageUrl,
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

class VendorHoursRow extends StatelessWidget {
  String formatTo12Hour(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;

    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  const VendorHoursRow({
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: context.typography.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: isEnabled ? null : Colors.red,
            ),
          ),
          isEnabled
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTo12Hour(startTime ?? ''),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(radius: 4.r, backgroundColor: Colors.green),
                    SizedBox(width: 20.w),
                    Text(
                      formatTo12Hour(endTime ?? ''),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(radius: 4.r, backgroundColor: Colors.red),
                  ],
                )
              : Text(
                  'Closed',
                  style: context.typography.body.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
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
    return Row(
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
    return location != null && location!.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white24,
                  child: Icon(
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
                        location!,
                        style: context.typography.body.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class VendorAvatar extends StatelessWidget {
  const VendorAvatar({
    super.key,
    this.vendorProfileImage,
    this.hasPermit = false,
  });
  final String? vendorProfileImage;
  final bool hasPermit;

  @override
  Widget build(BuildContext context) {
    // Debug print to track when widget rebuilds
    debugPrint('🎨 VendorAvatar rebuild - hasPermit: $hasPermit');

    return GestureDetector(
      onTap: () {
        VendorHomeService.gotoVendorProfile(context);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              backgroundColor: context.colors.buttonPrimary,
              radius: 36.r,
              backgroundImage: vendorProfileImage != null
                  ? NetworkImage(vendorProfileImage!)
                  : null,
              child: vendorProfileImage != null
                  ? null
                  : Icon(Icons.person, color: Colors.white, size: 40.w),
            ),
          ),
          // Badge visibility debug
          if (hasPermit)
            Positioned(
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  debugPrint('✨ Rendering badge - hasPermit is TRUE');
                  return CustomPaint(
                    size: const Size(26, 26),
                    painter: RPSCustomPainter(),
                  );
                },
              ),
            )
          else
            Builder(
              builder: (context) {
                debugPrint('⚠️ Badge hidden - hasPermit is FALSE');
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.blue,
      child: Icon(Icons.chat_bubble_outline, color: Colors.white),
    );
  }
}
