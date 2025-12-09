import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/profile/widgets/profile_image_picker.dart';

class VendorEditProfileScreen extends StatefulWidget {
  const VendorEditProfileScreen({super.key});

  @override
  State<VendorEditProfileScreen> createState() =>
      _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  final _vendorProfileService = VendorProfileService();
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  late String _selectedVendorType;

  bool isLoading = false;
  late String? _imageUrl;

  @override
  void initState() {
    setDataFromSession();
    super.initState();
  }

  final _session = SessionController();
  void setDataFromSession() {
    final vendor = _session.vendor!;
    final vendorName = vendor.name;
    final vendorType = vendor.vendorType;
    final image = vendor.profileImage;
    final address = vendor.address;
    setState(() {
      _nameController.text = vendorName;
      _addressController.text = address ?? '';
      _selectedVendorType = vendorType;
      _imageUrl = image;
      debugPrint('here ${vendor.profileImage}');
    });
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
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //profile image picker (ProfileImagePicker)
                ImagePickerAvatar(
                  readOnly: isLoading,
                  initialUrl: _imageUrl,
                  onImageChanged: (url) {
                    _imageUrl = url;
                    debugPrint('url: $url');
                    debugPrint('_imageUrl: $_imageUrl');
                  },
                ),
                SizedBox(height: 24.h),
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
                SizedBox(height: 16.h),
                Text(
                  'Address',
                  style: context.typography.title.copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  hint: 'Enter shop address',
                  controller: _addressController,
                  readOnly: isLoading,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Text(
                  'Type',
                  style: context.typography.title.copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 10.h),
                //vendorTypes list is imported from app_constants.dart
                MyDropdown(
                  items: TypeAndCategoryConstants.vendorTypes,
                  value: _selectedVendorType.isNotEmpty
                      ? _selectedVendorType
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _selectedVendorType = value!;
                    });
                  },
                  hint: 'Choose a Category',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vendor Type is required.';
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

                    await _vendorProfileService.updateVendorProfile(
                      context,
                      name: _nameController.text,
                      shopAddress: _addressController.text,
                      vendorType: _selectedVendorType,
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
