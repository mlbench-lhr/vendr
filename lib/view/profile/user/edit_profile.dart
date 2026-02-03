import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
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

  // Initial values for change detection
  late String _initialName;
  late String? _initialImageUrl;

  @override
  void initState() {
    setDataFromSession();
    // Add listener to rebuild when values change
    _nameController.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onValueChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    if (mounted) setState(() {});
  }

  final _session = SessionController();
  void setDataFromSession() {
    final user = _session.user!;
    final userName = user.name;
    final image = user.imageUrl;
    setState(() {
      _nameController.text = userName;
      _imageUrl = image;

      // Store initial values for change detection
      _initialName = userName;
      _initialImageUrl = image;
      debugPrint('here ${user.imageUrl}');
    });
  }

  /// Check if any value has changed from initial
  bool get _hasChanges {
    return _nameController.text != _initialName ||
        _imageUrl != _initialImageUrl;
  }

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
                      // Trigger rebuild for change detection
                      if (mounted) setState(() {});
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
                  label: 'Update',
                  onPressed: _hasChanges && !isLoading
                      ? () async {
                          if (!formKey.currentState!.validate()) return;
                          if (mounted) {
                            setState(() => isLoading = true);
                          }
                          await _userProfileService.updateUserProfile(
                            context,
                            name: _nameController.text,
                            imageUrl: _imageUrl,
                            onSuccess: () {
                              // Update initial values after successful save
                              _initialName = _nameController.text;
                              _initialImageUrl = _imageUrl;
                              Navigator.pop(context);
                              context.flushBarSuccessMessage(
                                message: 'Profile updated successfully!',
                              );
                            },
                          );
                          if (mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
