import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class UserEditProfileScreen extends StatefulWidget {
  const UserEditProfileScreen({super.key});

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // return MyScaffold(
    //   appBar: AppBar(
    //     title: Center(
    //       child: Text(
    //         'Edit Profile',
    //         style: context.typography.title.copyWith(
    //           fontSize: 20.sp,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Center(
    //       child: Column(
    //         children: [
    // CircleAvatar(
    //   radius: 40.r,
    //   child: CircleAvatar(
    //     radius: 38.r,
    //     backgroundColor: Colors.white70,
    //     backgroundImage: NetworkImage(
    //       'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    //     ),
    //   ),
    // ),
    //           SizedBox(height: 40.h),
    //           Text(
    //             'Name',
    //             style: context.typography.label.copyWith(
    //               fontSize: 15.sp,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           SizedBox(height: 10.h),
    //           MyTextField(suffixIcon: Icon(Icons.person_2_outlined)),
    //           const Spacer(),
    //           MyButton(
    //             label: 'Save',
    //             onPressed: () {
    //               debugPrint('Save button pressed');
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

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
                      'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
              MyTextField(
                hint: 'Enter your name',
                suffixIcon: Icon(Icons.person_outline),
              ),
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
