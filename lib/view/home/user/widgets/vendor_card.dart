import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_text_button.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';
import 'package:vendr/view/home/user/widgets/menu_bottom_sheet.dart';
import 'package:vendr/view/home/user/widgets/small_badge.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorCard extends StatefulWidget {
  final bool isExpanded;
  final bool isRouteSet;
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
  final bool hasPermit;

  const VendorCard({
    super.key,
    required this.isExpanded,
    required this.isRouteSet,
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
    this.hasPermit = false,
  });

  @override
  State<VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  ///
  ///Check if card is expanded
  ///
  @override
  void didUpdateWidget(covariant VendorCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect change from false → true
    if (!oldWidget.isExpanded && widget.isExpanded) {
      debugPrint('EXPANDED!!!');
      getVendorDetails();
    }
  }

  final _userHomeService = UserHomeService();
  final userProfileService = UserProfileService();
  bool isLoading = false;
  VendorModel? selectedVendorDetails;

  Future<void> getVendorDetails() async {
    setState(() {
      isLoading = true;
    });
    //Load vendor profile
    final response = await _userHomeService.getVendorDetails(
      context: context,
      vendorId: widget.vendorId,
    );
    if (response != null) {
      setState(() {
        selectedVendorDetails = response;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isFavorite = false;

  final _sessionController = SessionController();

  void checkIfFavorite() {
    final List<FavoriteVendorModel> favoriteVendors =
        _sessionController.user?.favoriteVendors ?? [];

    final bool exists = favoriteVendors.any(
      (vendor) => vendor.id == widget.vendorId,
    );

    if (exists) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

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
              child: isLoading
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
                  child: Column(
                    children: [
                      SizedBox(
                        width: 310.w,
                        child: MyButton(
                          label: "Get Direction",
                          onPressed: widget.onGetDirection,
                        ),
                      ),
                    ],
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
        CardMenuHeading(menu: selectedVendorDetails?.menu ?? []),
        // _buildMenuItems(items),
        _buildMenuItems(selectedVendorDetails?.menu ?? []),
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
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              backgroundColor: context.colors.buttonPrimary,
              radius: 23.r,
              child: CircleAvatar(
                radius: 21.r,
                backgroundColor: context.colors.primary,
                backgroundImage: widget.imageUrl.isNotEmpty
                    ? NetworkImage(widget.imageUrl)
                    : null,
                child: widget.imageUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 24.w)
                    : null,
              ),
            ),
            // Small badge for collapsed card - only show if vendor has permit
            if (widget.hasPermit)
              Positioned(
                right: 0,
                bottom: 0,
                child: CustomPaint(
                  size: Size(26 * 0.525, 26 * 0.525),
                  painter: SmallRPSCustomPainter(radius: 21.0),
                ),
              ),
          ],
        ),
        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            '${widget.distance.toString()}km',
            style: context.typography.label.copyWith(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.h, right: 10.w),
          child: GestureDetector(
            onTap: widget.onGetDirection,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFF2E323D),
              child: Icon(
                widget.isRouteSet
                    ? Icons.navigation
                    : Icons.navigation_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isFavoriteLoading = false;
  Widget _buildExpandedCardHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 42.r,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                backgroundColor: context.colors.buttonPrimary,
                radius: widget.isExpanded ? 40.r : 21.r,
                backgroundImage: widget.imageUrl.isNotEmpty
                    ? NetworkImage(widget.imageUrl)
                    : null,
                child: widget.imageUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 40.w)
                    : null,
              ),
            ),
            // Custom Octagon Badge - dynamically sized, only show if vendor has permit
            if (widget.hasPermit)
              Positioned(
                right: 0,
                bottom: 0,
                child: CustomPaint(
                  size: Size(
                    26 * (widget.isExpanded ? 1.0 : 0.525),
                    26 * (widget.isExpanded ? 1.0 : 0.525),
                  ),
                  painter: SmallRPSCustomPainter(
                    radius: widget.isExpanded ? 40.0 : 21.0,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 125.w,
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  widget.vendorName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: context.typography.title.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
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
        Padding(
          padding: EdgeInsets.only(top: 4.h, right: 10.w),
          child: GestureDetector(
            onTap: () async {
              setState(() {
                isFavoriteLoading = true;
                isFavorite = !isFavorite;
              });
              if (isFavorite) {
                await _userHomeService.addToFavorites(
                  context,
                  vendorId: widget.vendorId,
                );
              } else {
                await userProfileService.removeFromFavorites(
                  context,
                  vendorId: widget.vendorId,
                );
              }
              setState(() {
                isFavoriteLoading = false;
              });
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFF2E323D),
              child: isFavoriteLoading
                  ? LoadingWidget(color: Colors.white54)
                  : Icon(
                      isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.white,
                    ),
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
            widget.menuLength < 2
                ? '${widget.menuLength} Product'
                : '${widget.menuLength} Products',
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
        // CardVendorHoursHeading(hoursADay: widget.hoursADay ?? '0'),
        CardVendorHoursHeading(vendorHours: selectedVendorDetails!.hours),
        SizedBox(height: 16.h),
        if (selectedVendorDetails?.hours != null) ...[
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
            ),
            child: Column(
              children: [
                VendorHoursRow(
                  day: 'Monday',
                  startTime: selectedVendorDetails?.hours!.days.monday.start,
                  endTime: selectedVendorDetails?.hours!.days.monday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.monday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Tuesday',
                  startTime: selectedVendorDetails?.hours!.days.tuesday.start,
                  endTime: selectedVendorDetails?.hours!.days.tuesday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.tuesday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Wednesday',
                  startTime: selectedVendorDetails?.hours!.days.wednesday.start,
                  endTime: selectedVendorDetails?.hours!.days.wednesday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.wednesday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Thursday',
                  startTime: selectedVendorDetails?.hours!.days.thursday.start,
                  endTime: selectedVendorDetails?.hours!.days.thursday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.thursday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Friday',
                  startTime: selectedVendorDetails?.hours!.days.friday.start,
                  endTime: selectedVendorDetails?.hours!.days.friday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.friday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Saturday',
                  startTime: selectedVendorDetails?.hours!.days.saturday.start,
                  endTime: selectedVendorDetails?.hours!.days.saturday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.saturday.enabled ??
                      false,
                ),
                VendorHoursRow(
                  day: 'Sunday',
                  startTime: selectedVendorDetails?.hours!.days.sunday.start,
                  endTime: selectedVendorDetails?.hours!.days.sunday.end,
                  isEnabled:
                      selectedVendorDetails?.hours!.days.sunday.enabled ??
                      false,
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
        ],

        SizedBox(height: 10.h),
        CardReviewsSectionHeading(vendorId: widget.vendorId),
        _buildReviewsList(selectedVendorDetails?.reviews?.list ?? []),
        SizedBox(height: 75.h),
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
            const Spacer(),
            _actionButton(
              color: Colors.blue,
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onPressed: () {
                final userId = _sessionController.user?.id ?? '';
                final vendorId = widget.vendorId;
                // Generate a unique chat ID based on user and vendor IDs
                final chatId = '${userId}_$vendorId';

                Navigator.pushNamed(
                  context,
                  RoutesName.liveChat,
                  arguments: {
                    'chatId': chatId,
                    'vendorName': widget.vendorName,
                    'vendorImage': widget.imageUrl,
                    'isChatClosed': false,
                    'initialMessage': 'Hello! I would like to chat with you.',
                    'senderName': _sessionController.user?.name ?? 'User',
                    'receiverId': vendorId,
                    'hasPermit': widget.hasPermit,
                  },
                );
              },
            ),
            SizedBox(width: 12.w),
            _actionButton(
              icon: Icons.call_outlined,
              label: 'Call',
              onPressed: () async {
                if (selectedVendorDetails?.phone != null) {
                  debugPrint(
                    'Launching dialer: ${selectedVendorDetails!.phone}',
                  );
                  final Uri uri = Uri(
                    scheme: 'tel',
                    path: selectedVendorDetails!.phone,
                  );

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    debugPrint('Could not launch dialer');
                    if (context.mounted) {
                      context.flushBarErrorMessage(
                        message: 'Could not launch dialer',
                      );
                    }
                  }
                } else {
                  debugPrint('❌ Phone number is null');
                }
              },
            ),
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
    Color? color,
    String? label,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 14.w),
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF2E323D),
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
                    '${widget.distance.toString()}km',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
              Text(
                widget.vendorAddress,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodySmall.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(List<MenuItemModel> menuItems) {
    final reversedmenuItems = menuItems.reversed.toList();
    return reversedmenuItems.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            height: 200.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: reversedmenuItems.length,
              itemBuilder: (context, index) {
                return MenuItemTile(
                  onTap: () {
                    MyBottomSheet.show(
                      context,
                      isDismissible: true,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: context.colors.primary,
                      child: MenuBottomSheet(
                        menuItem: reversedmenuItems[index],
                      ),
                      // child: AddReviewBottomSheet(),
                    );
                  },
                  name: reversedmenuItems[index].itemName,
                  price: reversedmenuItems[index].servings.first.servingPrice,
                  imageUrl: reversedmenuItems[index].imageUrl,
                );
              },
              separatorBuilder: (_, _) => SizedBox(width: 16.w),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildReviewsList(List<SingleReviewModel> reviews) {
    return reviews.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewTile(
                name: reviews[index].user.name,
                rating: reviews[index].rating.toDouble(),
                timeStamp: _formatDate(reviews[index].createdAt),
                content: reviews[index].message,
              );
            },
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text('No reviews found.'),
            ),
          );
  }
}

String _formatDate(DateTime date) {
  return '${date.month}/${date.day}/${date.year}';
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
              maxLines: 2,
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
  const CardMenuHeading({super.key, required this.menu});
  final List<MenuItemModel> menu;
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
        Text('${menu.length} Products', style: TextStyle(fontSize: 10.sp)),
        const Spacer(),
        InkWell(
          onTap: () {
            UserHomeService.gotoVendorMenu(context, menu);
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
  const CardVendorHoursHeading({super.key, required this.vendorHours});
  final HoursModel? vendorHours;
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
          VendorHomeService.getVendorWorkingHoursToday(
            isUserSide: true,
            vendorHours: vendorHours,
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class CardReviewsSectionHeading extends StatelessWidget {
  const CardReviewsSectionHeading({super.key, required this.vendorId});
  final String vendorId;
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
            UserHomeService.gotoReviews(
              context,
              isVendor: false,
              vendorId: vendorId,
            );
          },
        ),
      ],
    );
  }
}
