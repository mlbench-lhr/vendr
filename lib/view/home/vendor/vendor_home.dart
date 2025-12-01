import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_button.dart';
import 'package:vendr/app/components/review_tile.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  List<Map<String, dynamic>> items = [
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
    {
      'id': 4,
      'name': 'Veggie tomato mix',
      'price': '\$100',
      'imageUrl':
          'https://assets.bonappetit.com/photos/5d4356436f98a4000898782b/4:3/w_3376,h_2532,c_limit/Basically-Ratatouille-Pasta.jpg',
    },
    {
      'id': 5,
      'name': 'Moi-moi and ekpa.',
      'price': '\$150',
      'imageUrl':
          'https://img-global.cpcdn.com/recipes/ca64e4220565f1b8/680x781cq80/ekuru-white-moi-moi-recipe-main-photo.jpg',
    },
    {
      'id': 6,
      'name': 'Egg and cucumber recipe',
      'price': '\$80',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSLE0q7GC9bUMkvUVCNH0tmVRaohM_jTeEyw&s',
    },
  ];

  List<Map<String, dynamic>> reviews = [
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

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.w),
        child: Center(
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
                        VendorAvatar(),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            8.height,
                            Text(
                              'Harry Brook',
                              style: context.typography.title.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Food Vendor',
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
                    LocationSection(),
                    SizedBox(height: 24.h),
                    //Menu heading
                    MenuHeading(),
                  ],
                ),
              ),
              //End: Menu heading
              SizedBox(height: 8.h),
              //Menu Items
              _buildMenuItems(items),
              //Vendor hours heading
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    //Reviews
                    _buildReviewsList(reviews),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(List<Map<String, dynamic>> menuItems) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 16.w),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuItemTile(
            name: menuItems[index]['name'],
            price: menuItems[index]['price'],
            imageUrl: menuItems[index]['imageUrl'],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 16.w);
        },
      ),
    );
  }
}

SizedBox _buildReviewsList(List<Map<String, dynamic>> reviews) {
  return SizedBox(
    child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (BuildContext context, int index) {
        return ReviewTile(
          name: reviews[index]['name'],
          rating: reviews[index]['rating'],
          timeStamp: reviews[index]['time_stamp'],
          content: reviews[index]['content'],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 12.h);
      },
    ),
  );
}

class VendorHoursCard extends StatelessWidget {
  const VendorHoursCard({
    super.key,
    required this.day,
    this.startTime,
    this.endTime,
    this.isOff = false,
  });
  final String day;
  final String? startTime;
  final String? endTime;
  final bool isOff;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isOff ? Colors.red : Colors.white12,
        borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: context.typography.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          isOff
              ? Text(
                  'Off',
                  style: context.typography.body.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Row(
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
                ),
        ],
      ),
    );
  }
}

class MenuHeading extends StatelessWidget {
  const MenuHeading({super.key});

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
          '25 Products',
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
          '8 Hours',
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
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                '15 Maiden Ln Suite 908, New York, NY 10038, United States',
                style: context.typography.body.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VendorAvatar extends StatelessWidget {
  const VendorAvatar({super.key});

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
          backgroundImage: NetworkImage(
            'https://cdn.cpdonline.co.uk/wp-content/uploads/2021/10/28122626/What-is-a-chef-hierarchy.jpg',
          ),
          // child: Icon(Icons.person, color: Colors.white, size: 40.w),
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
