import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';

class VendorCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final double distance;
  final String vendorName;
  final String vendorAddress;
  final String type;
  final String imageUrl;
  final String menu;
  final String hours;
  final VoidCallback? onGetDirection;
  final Widget Function(BuildContext context)? expandedBuilder;

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
          'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 2,
      'name': 'Jane Cooper',
      'rating': 2.5,
      'time_stamp': '4 hours ago',
      'content':
          'Velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
    },
    {
      'id': 3,
      'name': 'James Smith',
      'rating': 5.0,
      'time_stamp': '1 day ago',
      'content': 'Adipisicing qui sunt do rependerit ad laborum.',
    },
  ];

  VendorCard({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.distance,
    required this.vendorName,
    required this.vendorAddress,
    required this.type,
    required this.menu,
    required this.hours,
    this.expandedBuilder,
    this.onGetDirection,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final collapsedHeight = screenHeight * 0.18;
    final expandedHeight = screenHeight * 0.75;
    final double collapsedWidth = 350.w;
    final double expandedWidth = MediaQuery.of(context).size.width * 0.93;
    final double bottom = 25.h;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
      right: 14.w,
      bottom: bottom,
      child: GestureDetector(
        onTap: !isExpanded ? onTap : null,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: isExpanded
                    ? const Color(0xFF1B1C23)
                    : const Color(0xFF20232A),
              ),
              height: isExpanded ? expandedHeight : collapsedHeight,
              width: isExpanded ? expandedWidth : collapsedWidth,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isExpanded)
                      GestureDetector(
                        onTap: onTap,
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 32.w,
                          ),
                        ),
                      ),
                    _buildTopRow(context),
                    SizedBox(height: isExpanded ? 10.h : 30.h),
                    if (!isExpanded) _buildInfoRow(context),
                    SizedBox(height: isExpanded ? 5.h : 12.h),
                    if (isExpanded)
                      expandedBuilder != null
                          ? expandedBuilder!(context)
                          : _defaultExpandedContent(context),
                    if (isExpanded) SizedBox(height: 10.h),
                    if (isExpanded) MenuHeading(),
                    if (isExpanded) _buildMenuItems(items),
                    if (isExpanded) SizedBox(height: 20.h),
                    if (isExpanded) _buildVendorHoursAndReviews(context),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 320.w,
                    child: MyButton(
                      label: "Get Direction",
                      onPressed: onGetDirection,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Top row with avatar and action icon
  Widget _buildTopRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: isExpanded ? 45.r : 23.r,
          child: CircleAvatar(
            radius: isExpanded ? 43.r : 21.r,
            backgroundColor: context.colors.primary,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        isExpanded ? const Spacer() : SizedBox(width: 10.w),
        if (!isExpanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendorName,
                  style: context.typography.label.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  vendorAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.body.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        GestureDetector(
          onTap: isExpanded ? () {} : onGetDirection,
          child: CircleAvatar(
            radius: 23.r,
            backgroundColor: const Color(0xFF2E323D),
            child: isExpanded
                ? const Icon(Icons.star_outline_rounded, color: Colors.white)
                : const Icon(Icons.route_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Info row in collapsed state
  Widget _buildInfoRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _infoItem(context, Icons.copy_all_outlined, 'Type', type),
        ),
        SizedBox(width: 12.w),
        Expanded(child: _infoItem(context, Icons.menu_outlined, 'Menu', menu)),
        SizedBox(width: 12.w),
        Expanded(
          child: _infoItem(context, Icons.timer_outlined, 'Hours', hours),
        ),
      ],
    );
  }

  Widget _buildVendorHoursAndReviews(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VendorHoursHeading(),
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
              VendorHoursCard(day: 'Sunday', isOff: true),
            ],
          ),
          SizedBox(height: 24.h),
          ReviewsSectionHeading(),
          SizedBox(height: 16.h),
          _buildReviewsList(reviews),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// Default expanded content under avatar
  Widget _defaultExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendorName,
                  style: context.typography.label.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Food Vendor',
                  style: context.typography.label.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            _actionButton(Icons.call_outlined, 'Call'),
            _actionButton(Icons.share_outlined, 'Share'),
          ],
        ),
        SizedBox(height: 20.h),
        _locationRow(context),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2E323D),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 50.h,
      width: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: Colors.white),
          Text(label),
        ],
      ),
    );
  }

  Widget _locationRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: const Color(0xFF2E323D),
          child: const Icon(Icons.location_on_outlined, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Location',
                    style: context.typography.title.copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '${distance.toStringAsFixed(0)}m',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
              Text(vendorAddress, maxLines: 3, overflow: TextOverflow.ellipsis),
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
            name: menuItems[index]['name'],
            price: menuItems[index]['price'],
            imageUrl: menuItems[index]['imageUrl'],
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
      ),
    );
  }

  SizedBox _buildReviewsList(List<Map<String, dynamic>> reviews) {
    return SizedBox(
      child: ListView.separated(
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
      ),
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
        radius: 20.r,
        backgroundColor: const Color(0xFF2E323D),
        child: Icon(icon, color: Colors.white),
      ),
      SizedBox(width: 8.w),
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
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.label.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    ],
  );
}
