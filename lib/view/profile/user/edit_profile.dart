import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/view/profile/widgets/profile_image_picker.dart';

class UserEditProfileScreen extends StatefulWidget {
  const UserEditProfileScreen({super.key});

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final _userProfileService = UserProfileService();
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool isLoading = false;
  late String? _imageUrl;

  @override
  void initState() {
    setDataFromSession();
    super.initState();
  }

  final _session = SessionController();
  void setDataFromSession() {
    final user = _session.user!;
    final userName = user.name;
    final image = user.imageUrl;
    setState(() {
      _nameController.text = userName;
      _imageUrl = image;
      debugPrint('here ${user.imageUrl}');
    });
  }

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
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Center(
                  child: //profile image picker (ProfileImagePicker)
                  ImagePickerAvatar(
                    readOnly: isLoading,
                    initialUrl: _imageUrl,
                    onImageChanged: (url) {
                      _imageUrl = url;
                      debugPrint('url: $url');
                      debugPrint('_imageUrl: $_imageUrl');
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Name',
                  style: context.typography.title.copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  hint: 'Enter your name',
                  controller: _nameController,
                  readOnly: isLoading,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    } else if (!value.nameValidator()) {
                      return 'Name must contain only alphabets and spaces.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                MyButton(
                  isLoading: isLoading,
                  label: 'Save',
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    if (mounted) {
                      setState(() => isLoading = true);
                    }
                    await _userProfileService.updateUserProfile(
                      context,
                      name: _nameController.text,
                      imageUrl: _imageUrl,
                      onSuccess: () {
                        context.flushBarSuccessMessage(
                          message: 'Profile updated successfully!',
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
        ),
      ),
    );
  }
}
