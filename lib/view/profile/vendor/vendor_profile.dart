import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/services/common/location_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/home/vendor/widgets/custom_badge.dart';
import 'package:vendr/view/profile/widgets/delete_account_dialog.dart';
import 'package:vendr/view/profile/widgets/logout_account_dialog.dart';
import 'package:vendr/view/profile/widgets/profile_menu_tile.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  bool _hasPermit = false;
  final sessionController = SessionController();

  void DataFromSession() {
    final vendor = sessionController.vendor!;
    setState(() {
      _hasPermit = vendor.hasPermit ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    DataFromSession();
    sessionController.addListener(_onSessionChanged);
  }

  void _onSessionChanged() {
    if (mounted) {
      DataFromSession();
    }
  }

  @override
  void dispose() {
    sessionController.removeListener(_onSessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VendorModel vendor = sessionController.vendor!;
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      backgroundColor: context.colors.buttonPrimary,
                      radius: 36.r,
                      backgroundImage: vendor.profileImage != null
                          ? NetworkImage(vendor.profileImage!)
                          : null,
                      child: vendor.profileImage != null
                          ? null
                          : Icon(Icons.person, color: Colors.white, size: 40.w),
                    ),
                  ),
                  // Custom Octagon Badge
                  if (_hasPermit)
                    Positioned(
                      left: 220,
                      bottom: 0,
                      child: CustomPaint(
                        size: const Size(26, 26),
                        painter: RPSCustomPainter(),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                textAlign: TextAlign.center,
                vendor.name,
                style: context.typography.title.copyWith(fontSize: 20.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                textAlign: TextAlign.center,
                vendor.email!,
                style: context.typography.bodySmall.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              //Menus
              ProfileMenuTile(
                title: 'Edit Profile',
                icon: Icons.person_outline,
                onTap: () {
                  VendorProfileService.gotoVendorEditProfile(context);
                },
              ),

              // ProfileMenuTile(
              //   title: 'Location',
              //   icon: Icons.location_on_outlined,
              //   onTap: () {
              //     VendorProfileService.gotoVendorLocation(context);
              //   },
              // ),
              // TODO: Later Add Location Button
              // ProfileMenuTile(
              //   title: 'Location',
              //   icon: Icons.location_on_outlined,
              //   onTap: () {
              //     Geolocator.openAppSettings();
              //   },
              // ),
              ProfileMenuTile(
                title: 'Location',
                icon: Icons.location_on_outlined,
                onTap: () {
                  VendorProfileService.gotoVendorLocation(context);
                },
              ),

              ProfileMenuTile(
                title: 'Vendor Hours',
                icon: Icons.alarm_outlined,
                onTap: () {
                  VendorProfileService.gotoVendorHours(context);
                },
              ),
              ProfileMenuTile(
                title: 'Language',
                icon: Icons.language_outlined,
                onTap: () {
                  VendorProfileService.gotoLanguagesScreen(context);
                },
              ),
              ProfileMenuTile(
                title: 'My Menu',
                icon: Icons.receipt_outlined,
                onTap: () {
                  VendorProfileService.gotoVendorMyMenu(context);
                },
              ),
              ProfileMenuTile(
                title: 'Change Phone Number',
                icon: Icons.phone_outlined,
                onTap: () {
                  VendorProfileService.gotoChangePhoneNumber(context);
                },
              ),
              // ProfileMenuTile(
              //   title: 'Change Email',
              //   icon: Icons.mail_outline,
              //   onTap: () {
              //     VendorProfileService.gotoChangeEmail(context);
              //   },
              // ),
              ProfileMenuTile(
                title: 'Change Password',
                icon: Icons.password_outlined,
                onTap: () {
                  AuthService.gotoChangePassword(context);
                },
              ),
              ProfileMenuTile(
                title: 'Delete Account',
                icon: Icons.delete_outline,
                onTap: () {
                  //
                  showDialog<void>(
                    context: context,
                    builder: (_) => DeleteAccountDialog(isVendor: true),
                  );
                },
                showArrow: false,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: MyButton(
                  label: 'Log Out',
                  onPressed: () {
                    debugPrint('Logout button pressed');
                    showDialog<void>(
                      context: context,
                      builder: (_) => LogoutAccountDialog(),
                    );
                    VendorLocationService().stopSharing();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
