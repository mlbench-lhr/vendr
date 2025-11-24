import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/view/profile/vendor/vendor_profile.dart';
import 'package:vendr/view/profile/widgets/delete_account_dialog.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                textAlign: TextAlign.center,
                'Joey Tribbiani',
                style: context.typography.title.copyWith(fontSize: 20.sp),
              ),
              SizedBox(height: 12.h),
              //Menus
              ProfileMenuTile(
                title: 'Edit Profile',
                icon: Icons.person_2_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Location',
                icon: Icons.my_location_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Favourite Venders',
                icon: Icons.star_border_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Change Password',
                icon: Icons.password_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Notification Preferences',
                icon: Icons.notifications_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Language',
                icon: Icons.language_outlined,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              ProfileMenuTile(
                title: 'Delete Account',
                icon: Icons.delete_outline,
                onTap: () {
                  //
                  showDialog<void>(
                    context: context,
                    builder: (_) => DeleteAccountDialog(),
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
                    AuthService.logout(context);
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
