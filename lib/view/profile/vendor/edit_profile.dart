import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class VendorEditProfileScreen extends StatefulWidget {
  const VendorEditProfileScreen({super.key});

  @override
  State<VendorEditProfileScreen> createState() =>
      _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Center(
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundColor: context.colors.buttonPrimary,
                  child: CircleAvatar(
                    radius: 43.r,
                    backgroundColor: Colors.white70,
                    backgroundImage: NetworkImage(
                      'https://cdn.cpdonline.co.uk/wp-content/uploads/2021/10/28122626/What-is-a-chef-hierarchy.jpg',
                    ),
                    child: Icon(
                      Icons.camera_enhance_outlined,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 36.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Name',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 10.h),
              MyTextField(),

              SizedBox(height: 16.h),
              Text(
                'Type',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 10.h),
              MyTextField(hint: 'e.g., Food Vendor'),
              const Spacer(),
              MyButton(
                label: 'Save',
                onPressed: () {
                  debugPrint('Save button pressed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
