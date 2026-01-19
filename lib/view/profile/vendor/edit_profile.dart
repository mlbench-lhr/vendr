import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/env.dart';
import 'package:vendr/services/common/location_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/profile/widgets/address_autocomplete.dart';
import 'package:vendr/view/profile/widgets/profile_image_picker.dart';

class VendorEditProfileScreen extends StatefulWidget {
  const VendorEditProfileScreen({super.key});

  @override
  State<VendorEditProfileScreen> createState() =>
      _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  final _vendorProfileService = VendorProfileService();
  final _locationService = VendorLocationService();
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  late String _selectedVendorType;
  double _lat = 0;
  double _lng = 0;
  LatLng? selectedLatLng;

  bool isLoading = false;
  bool _isLocationLoading = false;
  late String? _imageUrl;

  @override
  void initState() {
    setDataFromSession();
    super.initState();
  }

  final _session = SessionController();
  void setDataFromSession() {
    final vendor = _session.vendor!;
    final address = vendor.address;
    setState(() {
      _nameController.text = vendor.name;
      _addressController.text = address ?? '';
      _lat = vendor.lat ?? 0;
      _lng = vendor.lng ?? 0;
      _selectedVendorType = vendor.vendorType;
      _imageUrl = vendor.profileImage;
      debugPrint('here ${vendor.profileImage}');
    });
  }

  /// Toggle location sharing ON/OFF
  Future<void> _toggleLocationSharing() async {
    if (_isLocationLoading) return;

    setState(() => _isLocationLoading = true);

    try {
      if (_locationService.isSharing) {
        await _locationService.stopSharing();
        debugPrint('🛑 Location sharing stopped');
      } else {
        await _locationService.startSharing();
        debugPrint('✅ Location sharing started');
      }
    } catch (e) {
      debugPrint('❌ Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) setState(() => _isLocationLoading = false);
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
            child: SingleChildScrollView(
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
                  Row(
                    children: [
                      Text(
                        'Address',
                        style: context.typography.title.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      4.width,
                      Text(
                        '(Optional)',
                        style: context.typography.bodySmall.copyWith(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  ///
                  ///Address autocomplete
                  ///
                  AddressAutocompleteTextField(
                    controller: _addressController,
                    apiKey: Env.placesApiKey,
                    readOnly: isLoading,
                    hint: 'Enter shop address',
                    onAddressSelected: (AddressResult result) {
                      _addressController.text = result.address;
                      _lat = result.latitude;
                      _lng = result.longitude;
                      if (mounted) {
                        setState(() {
                          selectedLatLng = LatLng(_lat, _lng);
                          debugPrint(' L A T. L N G. S E T');
                        });
                      }
                    },
                    onChanged: (value) {
                      //reset lat lng if address is changed manually
                      _lat = 0;
                      _lng = 0;
                      if (mounted) {
                        setState(() {
                          selectedLatLng = null;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null &&
                          value!.isNotEmpty &&
                          _lat == 0 &&
                          _lng == 0) {
                        return 'LatLng not set';
                      }
                      return null;
                    },
                  ),

                  ///
                  ///END: Address autocomplete
                  ///
                  SizedBox(height: 16.h),
                  _buildLocationToggle(),
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
                  SizedBox(height: 24.h),
                  MyButton(
                    isLoading: isLoading,
                    label: 'Save',
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      if (_addressController.text.isNotEmpty &&
                          (_lat == 0 || _lng == 0)) {
                        context.flushBarErrorMessage(
                          message:
                              'Please enter a valid address or leave the field empty.',
                        );
                        return;
                      }

                      if (mounted) {
                        setState(() => isLoading = true);
                      }

                      await _vendorProfileService.updateVendorProfile(
                        context,
                        name: _nameController.text,
                        shopAddress: _addressController.text,
                        lat: _lat,
                        lng: _lng,
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
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationToggle() {
    final isSharing = _locationService.isSharing;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isSharing ? Colors.green.withOpacity(0.2) : Colors.white12,
        borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        border: Border.all(color: isSharing ? Colors.green : Colors.white24),
      ),
      child: Row(
        children: [
          Icon(
            isSharing ? Icons.location_on : Icons.location_off,
            color: isSharing ? Colors.green : Colors.white70,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Location',
                  style: context.typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  isSharing
                      ? 'Customers can see you on map'
                      : 'Share your location to be visible',
                  style: context.typography.bodySmall.copyWith(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          _isLocationLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Switch(
                  value: isSharing,
                  onChanged: (_) => _toggleLocationSharing(),
                  activeColor: Colors.green,
                ),
        ],
      ),
    );
  }
}
