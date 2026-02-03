import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/profile/widgets/delete_account_dialog.dart';
import 'package:vendr/view/profile/widgets/logout_account_dialog.dart';
import 'package:vendr/view/profile/widgets/profile_menu_tile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen> {
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
    final UserModel user = sessionController.user!;
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
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white70,
                child: CircleAvatar(
                  backgroundColor: context.colors.primary,
                  radius: 38.r,
                  backgroundImage: user.imageUrl != null
                      ? NetworkImage(user.imageUrl!)
                      : null,
                  child: user.imageUrl != null
                      ? null
                      : Icon(Icons.person, color: Colors.white, size: 40.w),
                ),
              ),

              SizedBox(height: 16.h),
              Text(
                textAlign: TextAlign.center,
                user.name,
                style: context.typography.title.copyWith(fontSize: 20.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                textAlign: TextAlign.center,
                user.email,
                style: context.typography.bodySmall.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              //Menus
              ProfileMenuTile(
                title: 'Edit Profile',
                icon: Icons.person_2_outlined,
                onTap: () {
                  UserProfileService.gotoUserEditProfile(context);
                },
              ),

              // LocationMenuTile(
              //   title: 'Location',
              //   icon: Icons.my_location_outlined,
              // ),
              ProfileMenuTile(
                title: 'Location',
                icon: Icons.location_on_outlined,
                onTap: () {
                  Geolocator.openAppSettings();
                },
              ),
              // ProfileMenuTile(
              //   title: 'Location',
              //   icon: Icons.location_on_outlined,
              //   onTap: () {
              //     UserProfileService.gotoUserLocationProfile(context);
              //   },
              // ),
              ProfileMenuTile(
                title: 'Favorite Venders',
                icon: Icons.star_border_outlined,
                onTap: () {
                  UserProfileService.gotoUserFavorites(context);
                },
              ),
              ProfileMenuTile(
                title: 'Change Password',
                icon: Icons.password_outlined,
                onTap: () {
                  AuthService.gotoChangePassword(context);
                },
              ),
              ProfileMenuTile(
                title: 'Notification Preferences',
                icon: Icons.notifications_outlined,
                onTap: () {
                  UserProfileService.gotoNotificationPreferences(context);
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
                title: 'Delete Account',
                icon: Icons.delete_outline,
                onTap: () {
                  //
                  showDialog<void>(
                    context: context,
                    builder: (_) => DeleteAccountDialog(isVendor: false),
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
                    showDialog<void>(
                      context: context,
                      builder: (_) => LogoutAccountDialog(),
                    );
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

// class LocationMenuTile extends StatefulWidget {
//   const LocationMenuTile({super.key, required this.title, required this.icon});
//   final String title;
//   final IconData icon;

//   @override
//   State<LocationMenuTile> createState() => _LocationMenuTileState();
// }

// class _LocationMenuTileState extends State<LocationMenuTile> {
//   bool switchValue = true;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
//       color: Colors.transparent,
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 18.r,
//             backgroundColor: Colors.white24,
//             child: Icon(widget.icon, color: Colors.white, size: 20.w),
//           ),
//           SizedBox(width: 12.w),
//           Text(widget.title, style: context.typography.title.copyWith()),
//           const Spacer(),
//           Switch(
//             value: switchValue,
//             onChanged: (value) {
//               setState(() {
//                 switchValue = value;
//                 debugPrint('Location set to: $switchValue');
//               });
//             },
//             activeColor: Colors.white,
//             activeTrackColor: context.colors.buttonPrimary,
//             inactiveThumbColor: Colors.white,
//             inactiveTrackColor: Colors.white70,
//           ),
//         ],
//       ),
//     );
//   }
// }
