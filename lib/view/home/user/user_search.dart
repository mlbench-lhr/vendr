import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/user/user_home_service.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({
    super.key,
    required this.onVendorSelected,
    required this.userLocation,
  });
  final void Function(VendorModel vendor) onVendorSelected;
  final LatLng userLocation;

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VendorModel> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  double searchRadius = 5;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults.clear();
          _isLoading = false;
        });
      }
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      setState(() => _isLoading = true);

      try {
        final results = await UserHomeService().searchVendors(
          context: context,
          query: query,
          userLocation: widget.userLocation,
          searchRadius: searchRadius,
        );

        if (!mounted) return;

        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ErrorHandler.handle(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            MyTextField(
              controller: _searchController,
              textCapitalization: TextCapitalization.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _debounce?.cancel();
                        setState(() {
                          _searchController.clear();
                          _searchResults.clear();
                          _isLoading = false;
                        });
                      },
                    )
                  : null,
              borderRadius: 30,
              hint: 'e.g., Food Vendor',
              onChanged: _onSearchChanged,
            ),
            26.verticalSpace,
            _buildDistanceSlider(),
            20.verticalSpace,
            Expanded(
              child: _isLoading
                  ? Center(child: const LoadingWidget(color: Colors.white54))
                  : _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        'No vendors found',
                        style: context.typography.body,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => Divider(height: 16.h),
                      itemBuilder: (_, index) {
                        final vendor = _searchResults[index];
                        return ListTile(
                          onTap: () {
                            // Call callback before popping
                            widget.onVendorSelected(vendor);
                            log("Select vendor: ${vendor.name}");

                            log('Select vendor $vendor');
                            Navigator.pop(context);
                          },
                          leading:
                              (vendor.profileImage != null &&
                                  vendor.profileImage!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    vendor.profileImage!,
                                  ),
                                  backgroundColor: context.colors.buttonPrimary,
                                )
                              : (vendor.name.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundColor: context.colors.buttonPrimary,
                                  child: Text(vendor.name[0]),
                                )
                              : CircleAvatar(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),

                          title: Text(
                            vendor.name,
                            style: context.typography.body.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            vendor.vendorType,
                            style: context.typography.bodySmall.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Search Radius (${searchRadius.toInt()} km)',
            style: context.typography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Slider(
          value: searchRadius,
          min: 1,
          max: 100,
          divisions: 100,
          activeColor: context.colors.buttonPrimary,
          inactiveColor: Colors.grey[400],
          thumbColor: Colors.white,
          // label: '${searchRadius.toInt()} km',
          onChanged: (value) async {
            setState(() {
              searchRadius = value;
            });
            _onSearchChanged(_searchController.text);
          },
        ),
      ],
    );
  }
}
