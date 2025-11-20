import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/notifications/user/widgets/notifications_chip.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Notifications',
            style: context.typography.title.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            NotificationsChip(
              // imageUrl:
              //     'https://images.pexels.com/photos/135620/pexels-photo-135620.jpeg',
              title: 'New Vendor Nearby',
              description:
                  'A new vendor registered available in your vicinity, Explore Now',
            ),
            SizedBox(height: 30.h),
            NotificationsChip(
              // imageUrl:
              //     'https://images.pexels.com/photos/135620/pexels-photo-135620.jpeg',
              title: 'New Vendor Nearby',
              description:
                  '10 new vendors available in your vicinity, Explore Now',
            ),
            SizedBox(height: 30.h),
            NotificationsChip(
              imageUrl:
                  'https://media.istockphoto.com/id/1165683221/photo/chef-presents-something-on-a-black-background.jpg?s=2048x2048&w=is&k=20&c=ApuI0WnwG7GcVjB1hUDfJhNUeybcJa8P6hmYRrMav6Y=',
              title: 'Favorite Vendor Update',
              description:
                  'Your favourite vendor Harry Brook is nearby, Go Check them out!',
            ),
            SizedBox(height: 30.h),
            NotificationsChip(
              imageUrl:
                  'https://media.istockphoto.com/id/1165683221/photo/chef-presents-something-on-a-black-background.jpg?s=2048x2048&w=is&k=20&c=ApuI0WnwG7GcVjB1hUDfJhNUeybcJa8P6hmYRrMav6Y=',
              title: 'Favorite Vendor Update',
              description:
                  'Your favourite vendor Harry Brook updated their menu, Check new available options!',
            ),
          ],
        ),
      ),
    );
  }
}
