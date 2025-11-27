import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/profile/widgets/prefernces_chip.dart';

class NotificationPreferncesScreen extends StatefulWidget {
  const NotificationPreferncesScreen({super.key});

  @override
  State<NotificationPreferncesScreen> createState() =>
      _NotificationPreferncesScreenState();
}

class _NotificationPreferncesScreenState
    extends State<NotificationPreferncesScreen> {
  bool newVendorAlert = true;
  bool distanceBasedAlerts = true;
  bool favoriteVendorNotifications = true;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification Preferences',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            PreferncesChip(
              label: 'New Vendor Alerts',
              value: newVendorAlert,
              onChange: (bool newValue) {
                setState(() {
                  newVendorAlert = newValue;
                });
              },
            ),
            SizedBox(height: 15.h),
            PreferncesChip(
              label: 'Distance-based Alerts',
              value: distanceBasedAlerts,
              onChange: (bool newValue) {
                setState(() {
                  distanceBasedAlerts = newValue;
                });
              },
            ),
            SizedBox(height: 15.h),
            PreferncesChip(
              label: 'Favorite Vendor Notifications',
              value: favoriteVendorNotifications,
              onChange: (bool newValue) {
                setState(() {
                  favoriteVendorNotifications = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
