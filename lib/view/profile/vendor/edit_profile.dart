import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class VendorEditProfileScreen extends StatefulWidget {
  const VendorEditProfileScreen({super.key});

  @override
  State<VendorEditProfileScreen> createState() =>
      _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  final _nameController = TextEditingController();
  String _selectedVendorType = '';

  @override
  void initState() {
    super.initState();
    setDataFromSession();
  }

  final _session = SessionController();
  void setDataFromSession() {
    final vendor = _session.vendor!;
    final vendorName = vendor.name;
    final vendorType = vendor.vendorType;
    setState(() {
      _nameController.text = vendorName;
      _selectedVendorType = vendorType;
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
              MyTextField(hint: 'Enter your name', controller: _nameController),

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
