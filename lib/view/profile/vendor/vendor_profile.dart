import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/profile/widgets/delete_account_dialog.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
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
                backgroundColor: context.colors.buttonPrimary,
                radius: 40.r,
                backgroundImage: NetworkImage(
                  'https://cdn.cpdonline.co.uk/wp-content/uploads/2021/10/28122626/What-is-a-chef-hierarchy.jpg',
                ),
                // child: Icon(Icons.person, color: Colors.white, size: 40.w),
              ),
              SizedBox(height: 16.h),
              Text(
                textAlign: TextAlign.center,
                'Harry Brook',
                style: context.typography.title.copyWith(fontSize: 20.sp),
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
              ProfileMenuTile(
                title: 'Change Email',
                icon: Icons.mail_outline,
                onTap: () {
                  VendorProfileService.gotoChangeEmail(context);
                },
              ),
              ProfileMenuTile(
                title: 'Change Password',
                icon: Icons.password_outlined,
                onTap: () {},
              ),
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

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.showArrow = true,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.white24,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            Text(title, style: context.typography.title.copyWith()),
            const Spacer(),
            if (showArrow) Icon(Icons.arrow_forward_ios, size: 22.w),
          ],
        ),
      ),
    );
  }
}
