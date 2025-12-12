import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_text_button.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';
import 'package:vendr/view/home/user/widgets/menu_bottom_sheet.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';

class VendorCard extends StatefulWidget {
  final bool isExpanded;
  final bool isLoading;
  final VoidCallback onTap;
  final double distance;
  final String vendorId;
  final String vendorName;
  final String vendorAddress;
  final String vendorType;
  final String imageUrl;
  final int menuLength;
  final List<Map<String, dynamic>>? hours;
  final String? hoursADay;
  final VoidCallback? onGetDirection;
  final Widget Function(BuildContext context)? expandedBuilder;

  const VendorCard({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.distance,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorType,
    required this.menuLength,
    this.hours,
    required this.hoursADay,
    this.expandedBuilder,
    this.onGetDirection,
    required this.imageUrl,
    required this.vendorId,
    required this.isLoading,
  });

  @override
  State<VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  // Sample data
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'Veggie tomato mix',
      'price': '\$100',
      'imageUrl':
          'https://assets.bonappetit.com/photos/5d4356436f98a4000898782b/4:3/w_3376,h_2532,c_limit/Basically-Ratatouille-Pasta.jpg',
    },
    {
      'id': 2,
      'name': 'Moi-moi and ekpa.',
      'price': '\$150',
      'imageUrl':
          'https://img-global.cpcdn.com/recipes/ca64e4220565f1b8/680x781cq80/ekuru-white-moi-moi-recipe-main-photo.jpg',
    },
    {
      'id': 3,
      'name': 'Egg and cucumber recipe',
      'price': '\$80',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSLE0q7GC9bUMkvUVCNH0tmVRaohM_jTeEyw&s',
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'id': 1,
      'name': 'Cameron Williamson',
      'rating': 4.0,
      'time_stamp': '2 mins ago',
      'content':
          'Consequat velit qui adipisicing sunt do repe nderit ad laborum tempor ullamco.',
    },
    {
      'id': 2,
      'name': 'Jane Cooper',
      'rating': 2.5,
      'time_stamp': '4 hours ago',
      'content':
          'Velit qui adipisicing sunt do repe nderit ad laborum tempor ullamco.',
    },
    {
      'id': 3,
      'name': 'James Smith',
      'rating': 5.0,
      'time_stamp': '1 day ago',
      'content': 'Adipisicing qui sunt do repe nderit ad laborum.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final collapsedHeight = screenHeight * 0.18;
    final expandedHeight = screenHeight * 0.83;
    final double collapsedWidth = 350.w;
    final double expandedWidth = MediaQuery.of(context).size.width * 0.93;
    final double bottom = 25.h;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
      right: 14.w,
      bottom: bottom,
      child: GestureDetector(
        onTap: !widget.isExpanded ? widget.onTap : null,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: widget.isExpanded
                    ? const Color(0xFF1B1C23)
                    : const Color(0xFF20232A),
              ),
              height: widget.isExpanded ? expandedHeight : collapsedHeight,
              width: widget.isExpanded ? expandedWidth : collapsedWidth,
              child: widget.isLoading
                  ? Center(child: LoadingWidget(color: Colors.white))
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isExpanded)
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  size: 32.w,
                                ),
                              ),
                            ),

                          ///
                          ///
                          ///S T A R T F R O M H E R E !!!
                          ///
                          ///
                          widget.isExpanded
                              ? _buildExpandedCard(context)
                              : _buildCollapsedCard(),
                        ],
                      ),
                    ),
            ),
            if (widget.isExpanded)
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 320.w,
                    child: MyButton(
                      label: "Get Direction",
                      onPressed: widget.onGetDirection,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///Build Collapsed Card
  ///
  ///
  Column _buildCollapsedCard() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildCollapsedCardHeader(context),
      SizedBox(height: 32.h),
      _buildInfoRow(context),
    ],
  );

  ///
  ///
  ///Build Collapsed Card
  ///
  ///
  Column _buildExpandedCard(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildExpandedCardHeader(context),
        SizedBox(height: 15.h),
        widget.expandedBuilder != null
            ? widget.expandedBuilder!(context)
            : _defaultExpandedContent(context),
        SizedBox(height: 16.h),
        CardMenuHeading(),
        _buildMenuItems(items),
        SizedBox(height: 20.h),
        _buildVendorHoursAndReviews(context),
      ],
    );
  }

  /// Top row with avatar and action icon
  Widget _buildCollapsedCardHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: context.colors.buttonPrimary,
          radius: 23.r,
          child: CircleAvatar(
            radius: 21.r,
            backgroundColor: context.colors.primary,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
        ),
        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vendorName,
                style: context.typography.label.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.vendorAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.body.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.h, right: 10.w),
          child: GestureDetector(
            onTap: widget.onGetDirection,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFF2E323D),
              child: const Icon(Icons.navigation_outlined, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedCardHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: context.colors.buttonPrimary,
          radius: 42.r,
          child: CircleAvatar(
            radius: widget.isExpanded ? 40.r : 21.r,
            backgroundColor: context.colors.primary,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(top: 4.h, right: 10.w),
          child: GestureDetector(
            onTap: () {
              debugPrint('❗️To be implemented');
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFF2E323D),
              child: Icon(Icons.star_outline_rounded, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  ///
  /// Info row in collapsed state
  ///
  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _infoItem(
            context,
            Icons.copy_all_outlined,

            'Type',
            widget.vendorType,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _infoItem(
            context,
            Icons.menu_outlined,
            'Menu',
            '${widget.menuLength} Product(s)',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _infoItem(
            context,
            Icons.timer_outlined,
            'Hours',
            widget.hoursADay ?? '',
          ),
        ),
      ],
    );
  }

  Widget _buildVendorHoursAndReviews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardVendorHoursHeading(hoursADay: widget.hoursADay ?? '0'),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.w,
          children: [
            VendorHoursCard(
              day: 'Monday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(
              day: 'Tuesday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(
              day: 'Wednesday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(
              day: 'Thursday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(
              day: 'Friday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(
              day: 'Saturday',
              startTime: '09:00 AM',
              endTime: '06:00 PM',
            ),
            VendorHoursCard(day: 'Sunday', isEnabled: true),
          ],
        ),
        SizedBox(height: 24.h),
        CardReviewsSectionHeading(),
        _buildReviewsList(reviews),
        SizedBox(height: 56.h),
      ],
    );
  }

  /// Default expanded content under avatar
  Widget _defaultExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 125.w,
                  child: Text(
                    widget.vendorName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: context.typography.title.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.vendorType,
                  style: context.typography.label.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            const Spacer(),
            _actionButton(icon: Icons.call_outlined, label: 'Call'),
            12.width,
            _actionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    title: 'Check out this vendor!',
                    text:
                        '''Hey, I want to tell you about this amazing vendor!
                           ID: ${widget.vendorId}
                           Name: ${widget.vendorName}
                           Type: ${widget.vendorType}
                        ''',
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _locationRow(context),
      ],
    );
  }

  Widget _actionButton({
    IconData? icon,
    String? label,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2E323D),
          borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.white, size: 18.w),
            6.width,
            Text(
              label ?? '',
              style: context.typography.title.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: Colors.white24,
          child: Icon(
            Icons.location_on_outlined,
            color: Colors.white.withValues(alpha: 0.9),
            size: 18.w,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Location',
                    style: context.typography.title.copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${widget.distance.toStringAsFixed(0)}m',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
              Text(
                widget.vendorAddress,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodySmall.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(List<Map<String, dynamic>> menuItems) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 16.w),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return MenuItemTile(
            onTap: () {
              MyBottomSheet.show(
                context,
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                backgroundColor: context.colors.primary,
                child: MenuBottomSheet(),
                // child: AddReviewBottomSheet(),
              );
            },
            name: menuItems[index]['name'],
            price: menuItems[index]['price'],
            imageUrl: menuItems[index]['imageUrl'],
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
      ),
    );
  }

  Widget _buildReviewsList(List<Map<String, dynamic>> reviews) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ReviewTile(
          name: reviews[index]['name'],
          rating: reviews[index]['rating'],
          timeStamp: reviews[index]['time_stamp'],
          content: reviews[index]['content'],
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
    );
  }
}

/// Reusable info item row
Widget _infoItem(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 15.r,
        backgroundColor: Colors.white12,
        child: Icon(icon, color: Colors.white, size: 18.w),
      ),
      SizedBox(width: 4.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: context.typography.label.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.label.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    ],
  );
}

class CardMenuHeading extends StatelessWidget {
  const CardMenuHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: Colors.white24,
          child: Icon(
            Icons.receipt_outlined,
            color: Colors.white.withValues(alpha: 0.9),
            size: 18.w,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Menu',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 6.w),
        Text('25 Products', style: TextStyle(fontSize: 10.sp)),
        const Spacer(),
        InkWell(
          onTap: () {
            UserHomeService.gotoVendorMenu(context);
          },
          child: Text(
            'See All',
            style: context.typography.title.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.buttonPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class CardVendorHoursHeading extends StatelessWidget {
  const CardVendorHoursHeading({super.key, required this.hoursADay});
  final String hoursADay;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.alarm, color: Colors.white, size: 18.w),
        ),
        SizedBox(width: 12.w),
        Text(
          'Vendor Hours',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        const Spacer(),
        Text(
          hoursADay,
          style: context.typography.body.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class CardReviewsSectionHeading extends StatelessWidget {
  const CardReviewsSectionHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: Colors.white24,
          child: Icon(Icons.star_outline, color: Colors.white, size: 18.w),
        ),
        SizedBox(width: 12.w),
        Text(
          'Reviews',
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        const Spacer(),
        MyTextButton(
          label: 'View All',
          isDark: true,
          fontSize: 14.sp,
          onPressed: () {
            VendorHomeService.gotoReviews(
              //TODO: Change to User Homer Service
              context,
              isVendor: false,
            );
          },
        ),
      ],
    );
  }
}
