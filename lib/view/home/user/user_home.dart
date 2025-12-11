import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/provider/user_home_provider.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/view/home/user/widgets/location_permission_required.dart';
import 'package:vendr/view/home/user/widgets/vendor_card.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // Google Map controller and Polyline
  final Completer<GoogleMapController> _controller = Completer();
  late final PolylinePoints _polylinePoints;

  // Custom marker for vendors
  BitmapDescriptor? _customMarker;

  // Map styling
  String _mapStyle = '';
  bool _assetsLoaded = false;

  // UI states
  double? _distanceInKm;
  bool _isCardExpanded = false;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    _loadAssets();
    _polylinePoints = PolylinePoints(apiKey: KeyConstants.googleApiKey);

    // Load assets (map style and custom marker)

    // Get user location after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUserLocation());
  }

  bool permissionGranted = false;
  LocationPermission _locationPermissionStatus = LocationPermission.denied;
  Future<void> checkLocationPermission() async {
    var status = await Geolocator.checkPermission();
    setState(() => _locationPermissionStatus = status);
    permissionGranted =
        _locationPermissionStatus == LocationPermission.always ||
        _locationPermissionStatus == LocationPermission.whileInUse;

    debugPrint('Location Status: $permissionGranted');
    if (!permissionGranted) {
      //show bottom sheet here
      await _showLocationPermissionSheet();
    }
  }

  Future<void> _showLocationPermissionSheet() async {
    //show bottom sheet here
    if (mounted) {
      await MyBottomSheet.show(
        context,
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        useSafeArea: false,
        backgroundColor: context.colors.primary.withOpacity(0.0),
        child: LocationPermissionRequired(),
      );
      checkLocationPermission();
    }
  }

  /// Load map style and custom marker assets
  Future<void> _loadAssets() async {
    await _loadMapStyle();
    await _loadCustomMarker();
    if (mounted) setState(() => _assetsLoaded = true);
  }

  /// Load Google Map night theme style
  Future<void> _loadMapStyle() async {
    try {
      final stylePath = Assets.json.mapStyles.nightTheme;
      debugPrint("Loading map style from: $stylePath");

      _mapStyle = await rootBundle.loadString(stylePath);
      debugPrint("Map style loaded successfully!");
    } catch (e) {
      debugPrint("Could not load map style: $e");
    }
  }

  /// Load custom circular marker for vendors
  Future<void> _loadCustomMarker({
    double circleSize = 100,
    double imageSize = 60,
  }) async {
    try {
      // final data = await rootBundle.load('assets/images/home.png');
      final data = await rootBundle.load(Assets.images.shopMarker.path);
      final bytes = data.buffer.asUint8List();

      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      // Draw outer circle
      canvas.drawCircle(
        Offset(circleSize / 2, circleSize / 2),
        circleSize / 2,
        paint..color = const Color(0xFF21242B),
      );

      // Draw image at center
      final src = Rect.fromLTWH(
        0,
        0,
        fi.image.width.toDouble(),
        fi.image.height.toDouble(),
      );
      final double offset = (circleSize - imageSize) / 2;
      final dst = Rect.fromLTWH(offset, offset, imageSize, imageSize);
      canvas.drawImageRect(fi.image, src, dst, Paint());

      final picture = recorder.endRecording();
      final img = await picture.toImage(circleSize.toInt(), circleSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      _customMarker = BitmapDescriptor.fromBytes(
        byteData!.buffer.asUint8List(),
      );
    } catch (e) {
      debugPrint('Could not load custom circular marker: $e');
    }
  }

  /// Fetch user's current location
  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final provider = Provider.of<UserHomeProvider>(context, listen: false);
      provider.updateUserLocation(
        LatLng(position.latitude, position.longitude),
      );

      _moveCameraToUser();
    } catch (e) {
      debugPrint('Error while fetching location: $e');
    }
  }

  /// Move camera to user's current location
  Future<void> _moveCameraToUser() async {
    final provider = Provider.of<UserHomeProvider>(context, listen: false);
    if (provider.userLocation == null) return;

    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          // target: provider.userLocation!,
          target: const LatLng(31.4645193, 74.2540502),
          zoom: 15,
        ),
      ),
    );
  }

  /// Draw route from user to vendor
  Future<void> _drawRouteToVendor(LatLng vendor, int index) async {
    final provider = Provider.of<UserHomeProvider>(context, listen: false);
    final user = provider.userLocation;
    if (user == null) return;

    provider.clearPolylines();

    // Calculate straight-line distance
    final meters = Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      vendor.latitude,
      vendor.longitude,
    );
    setState(() => _distanceInKm = meters / 1000);

    try {
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(user.latitude, user.longitude),
          destination: PointLatLng(vendor.latitude, vendor.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isEmpty) {
        // Draw straight dashed line if no route
        provider.addOrReplacePolyline(
          Polyline(
            polylineId: PolylineId('straight_$index'),
            points: [user, vendor],
            width: 3,
            color: Colors.grey,
            patterns: [PatternItem.dash(10), PatternItem.gap(6)],
          ),
        );
      } else {
        // Draw actual route
        final coords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        provider.addOrReplacePolyline(
          Polyline(
            polylineId: PolylineId('route_$index'),
            points: coords,
            width: 5,
            color: Colors.blue,
          ),
        );
      }

      _zoomMapToBounds(user, vendor);
    } catch (e) {
      debugPrint('Error creating route: $e');
    }
  }

  /// Zoom map to show both user and vendor
  Future<void> _zoomMapToBounds(LatLng user, LatLng vendor) async {
    final controller = await _controller.future;

    final bounds = LatLngBounds(
      southwest: LatLng(
        user.latitude < vendor.latitude ? user.latitude : vendor.latitude,
        user.longitude < vendor.longitude ? user.longitude : vendor.longitude,
      ),
      northeast: LatLng(
        user.latitude > vendor.latitude ? user.latitude : vendor.latitude,
        user.longitude > vendor.longitude ? user.longitude : vendor.longitude,
      ),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  /// Main build method
  @override
  Widget build(BuildContext context) {
    return Consumer<UserHomeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: _assetsLoaded
              ? _buildMapStack(provider)
              : const Center(child: LoadingWidget(color: Colors.white)),
        );
      },
    );
  }

  /// User avatar in AppBar
  Widget _buildUserAvatar() {
    return GestureDetector(
      onTap: () {
        UserProfileService.gotoUserProfile(context);
      },
      child: CircleAvatar(
        backgroundColor: context.colors.navBarBackground,
        radius: 25.r,
        child: CircleAvatar(
          radius: 23.r,
          backgroundColor: context.colors.primary,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
        ),
      ),
    );
  }

  /// User greeting in AppBar
  Widget _buildUserGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Hey, Joey Tribbiani',
              style: context.typography.title.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(Icons.waving_hand_rounded, color: Color(0xFFFFDBAC)),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Discover vendors near you.',
          style: context.typography.label.copyWith(fontSize: 13.sp),
        ),
      ],
    );
  }

  /// Main stack containing map, search, distance, and vendor card
  Widget _buildMapStack(UserHomeProvider provider) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          _buildGoogleMap(provider),
          Align(
            alignment: Alignment.topCenter,
            child: GradientOverlay(height: 250.h),
          ),
          _buildHeader(),
          if (_distanceInKm != null && provider.selectedVendor != null)
            _buildVendorProfileBox(),
          if (provider.selectedVendor != null) _buildUserVendorCard(provider),
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 36.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        // color: context.colors.primary,
        // color: Colors.white10,
        borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildUserAvatar(),
              SizedBox(width: 10.w),
              _buildUserGreeting(),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  UserHomeService.gotoNotifications(context);
                },
                child: NotificationsBtn(),
              ),
            ],
          ),
          20.height,
          _buildSearchField(),
        ],
      ),
    );
  }

  /// Google Map widget
  Widget _buildGoogleMap(UserHomeProvider provider) {
    return GoogleMap(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
      initialCameraPosition: CameraPosition(
        // target: provider.userLocation ?? const LatLng(31.50293, 74.34801),
        target: provider.userLocation ?? const LatLng(31.4645193, 74.2540502),
        zoom: 14.4,
      ),
      markers: provider.buildMarkers(customMarker: _customMarker),
      polylines: provider.polylines,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) async {
        if (!_controller.isCompleted) _controller.complete(controller);
        await Future.delayed(const Duration(milliseconds: 200));
        if (_mapStyle.isNotEmpty) controller.setMapStyle(_mapStyle);
      },
      onTap: (pos) {
        provider.unselectVendor();
        setState(() {
          _distanceInKm = null;
          _isCardExpanded = false;
        });
      },
    );
  }

  /// Search field at top
  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () {
        UserHomeService.gotoSearch(context);
      },
      child: AbsorbPointer(
        child: MyTextField(
          borderRadius: 40.r,
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hint: 'Search Vendors',
        ),
      ),
    );
  }

  /// Distance box displayed above vendor card
  Widget _buildVendorProfileBox() {
    return Positioned(
      top: 480.h,
      left: 15.w,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'Distance: ${_distanceInKm!.toStringAsFixed(2)} km',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// Vendor card displayed at bottom
  Widget _buildUserVendorCard(UserHomeProvider provider) {
    final selectedVendor = provider.selectedVendor;
    if (selectedVendor == null) return const SizedBox.shrink();

    return VendorCard(
      isExpanded: _isCardExpanded,
      onTap: () => setState(() => _isCardExpanded = !_isCardExpanded),
      distance: _distanceInKm ?? 0.0,
      vendorName: selectedVendor.name,
      imageUrl: selectedVendor.profileImage ?? '',
      vendorAddress: selectedVendor.address ?? '',
      vendorType: selectedVendor.vendorType,
      menu: selectedVendor.menu ?? [],
      // hours: selectedVendor.hours,
      // hours: selectedVendor.hours ?? [],
      hoursADay: selectedVendor.hoursADay ?? '',
      onGetDirection: () async {
        if (selectedVendor.location != null) {
          await _drawRouteToVendor(
            selectedVendor.location!,
            provider.selectedVendorIndex ?? 0,
          );
          setState(() => _isCardExpanded = false);
        } else {
          context.flushBarErrorMessage(message: 'Location not Defined');
        }
      },
      vendorId: selectedVendor.id!,
    );
  }
}

class GradientOverlay extends StatelessWidget {
  final double height;

  const GradientOverlay({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white30, // top
            Colors.transparent, // bottom
          ],
        ),
      ),
    );
  }
}
