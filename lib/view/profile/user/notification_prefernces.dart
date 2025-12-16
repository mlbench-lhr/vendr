import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/view/profile/widgets/prefernces_chip.dart';

class NotificationPreferncesScreen extends StatefulWidget {
  const NotificationPreferncesScreen({super.key});

  @override
  State<NotificationPreferncesScreen> createState() =>
      _NotificationPreferncesScreenState();
}

class _NotificationPreferncesScreenState
    extends State<NotificationPreferncesScreen> {
  bool isLoading = false;

  final _sessionController = SessionController();
  final _userProfileService = UserProfileService();

  late bool newVendorAlert = true;
  late bool distanceBasedAlert = true;
  late bool favoriteVendorAlert = true;

  void setValuesFromSession() {
    final UserModel user = _sessionController.user!;
    setState(() {
      newVendorAlert = user.newVendorAlert ?? false;
      distanceBasedAlert = user.distanceBasedAlert ?? false;
      favoriteVendorAlert = user.favoriteVendorAlert ?? false;
    });
  }

  @override
  void initState() {
    setValuesFromSession();
    super.initState();
  }

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
        child: Column(
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
              value: distanceBasedAlert,
              onChange: (bool newValue) {
                setState(() {
                  distanceBasedAlert = newValue;
                });
              },
            ),
            SizedBox(height: 15.h),
            PreferncesChip(
              label: 'Favorite Vendor Notifications',
              value: favoriteVendorAlert,
              onChange: (bool newValue) {
                setState(() {
                  favoriteVendorAlert = newValue;
                });
              },
            ),
            const Spacer(),
            MyButton(
              isLoading: isLoading,
              label: 'Save',
              onPressed: () async {
                if (mounted) {
                  setState(() => isLoading = true);
                }
                await _userProfileService.updateUserProfile(
                  context,
                  newVendorAlert: newVendorAlert,
                  favoriteVendorAlert: favoriteVendorAlert,
                  distanceBasedAlert: distanceBasedAlert,
                  onSuccess: () {
                    context.flushBarSuccessMessage(
                      message: 'Settings updated successfully!',
                    );
                  },
                );
                if (mounted) {
                  setState(() => isLoading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
