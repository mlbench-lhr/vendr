import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/push_notifications_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
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

// List<VendorModel> initialVendors = [];
class _UserHomeScreenState extends State<UserHomeScreen> {
  final _userHomeService = UserHomeService();
  // Google Map controller and Polyline
  final Completer<GoogleMapController> _controller = Completer();
  late final PolylinePoints _polylinePoints;

  //Access Users Data
  final sessionController = SessionController();
  UserModel? get user => SessionController().user;

  // Custom marker for vendors
  BitmapDescriptor? _customMarker;

  // Map styling
  String _mapStyle = '';
  bool _assetsLoaded = false;

  // UI states
  // double? _distanceInKm;
  bool _isCardExpanded = false;
  bool _isRouteSet = false;
  bool _isUserLocationSet = false;

  // final List<VendorModel> vendors = List<VendorModel>.from(initialVendors);
  List<VendorModel> nearbyVendors = [];
  LatLng? _userLocation;
  int? _selectedVendorIndex;
  final Set<Polyline> _polylines = {};

  VendorModel? get selectedVendor => (_selectedVendorIndex != null)
      ? nearbyVendors[_selectedVendorIndex!]
      : null;
  Set<Polyline> get polylines => Set.unmodifiable(_polylines);

  @override
  void initState() {
    super.initState();
    sessionController.addListener(_onSessionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeMap());

    ///
    ///Initialize Push Notifications
    ///
    PushNotificationsService().initFCM(context: context);
  }

  Future<void> _initializeMap() async {
    _polylinePoints = PolylinePoints(apiKey: KeyConstants.googleApiKey);
    // Get user location after the first frame
    await checkLocationPermission();
    await _getUserLocation();
    getNearbyVendors();
    _loadAssets();
  }

  Future<void> getNearbyVendors() async {
    final List<VendorModel> vendorsResponse = await _userHomeService
        .getNearbyVendors(
          context: context,
          location: _userLocation,
          maxDistance: 50000000000, //km
        );
    setState(() {
      nearbyVendors = vendorsResponse;
      debugPrint('👨🏻 ${nearbyVendors.length} Vendor(s) found:');
      for (var initVendr in nearbyVendors) {
        debugPrint('ID: ${initVendr.id} Name: ${initVendr.name}');
      }
    });
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
    if (!mounted) return;
    await MyBottomSheet.show(
      context,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: false,
      child: const LocationPermissionRequired(),
    );
    checkLocationPermission();
  }

  void _onSessionChanged() {
    if (!mounted) return;
    setState(() {});
  }

  /// Load map style and custom marker assets
  Future<void> _loadAssets() async {
    await _loadMapStyle();
    await _loadCustomMarker();
    if (!mounted) return;
    setState(() => _assetsLoaded = true);
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
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      updateUserLocation(LatLng(position.latitude, position.longitude));

      _moveCameraToUser();
    } catch (e) {
      debugPrint('Error while fetching location: $e');
    }
  }

  /// Move camera to user's current location
  Future<void> _moveCameraToUser() async {
    if (_userLocation == null) return;
    debugPrint('📍USER LAT LNG ARE :$_userLocation');
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _userLocation ?? const LatLng(31.4645193, 74.2540502),
          zoom: 15,
        ),
      ),
    );
  }

  /// Draw route from user to vendor
  Future<void> _drawRouteToVendor(LatLng vendor, int index) async {
    debugPrint('_isDirectionSet $_isRouteSet');
    if (_isRouteSet) {
      clearPolylines();
      return;
    }

    setState(() {
      _isRouteSet = true;
    });

    final user = _userLocation;
    if (user == null) {
      // If user location is not available, just move camera to vendor
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
      selectVendor(index);
      return;
    }

    clearPolylines();

    // Calculate distance
    // final meters = Geolocator.distanceBetween(
    //   user.latitude,
    //   user.longitude,
    //   vendor.latitude,
    //   vendor.longitude,
    // );
    // setState(() => _distanceInKm = meters / 1000);

    try {
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(user.latitude, user.longitude),
          destination: PointLatLng(vendor.latitude, vendor.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isEmpty) {
        addOrReplacePolyline(
          Polyline(
            polylineId: PolylineId('straight_$index'),
            points: [user, vendor],
            width: 3,
            color: Colors.grey,
            patterns: [PatternItem.dash(10), PatternItem.gap(6)],
          ),
        );
      } else {
        final coords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        addOrReplacePolyline(
          Polyline(
            polylineId: PolylineId('route_$index'),
            points: coords,
            width: 5,
            color: Colors.blue,
          ),
        );
      }
      // Move camera to vendor after drawing route
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
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

  // ----------------- Provider methods moved here -----------------

  void updateUserLocation(LatLng newLocation) {
    if (_userLocation == newLocation) return;
    setState(() {
      _userLocation = newLocation;
      _isUserLocationSet = true;
    });
  }

  void selectVendor(int index) {
    if (index < 0 || index >= nearbyVendors.length) return;
    if (_selectedVendorIndex == index) return;
    setState(() {
      _selectedVendorIndex = index;
    });
  }

  Future<void> unselectVendor() async {
    if (_selectedVendorIndex == null && _polylines.isEmpty) return;
    setState(() {
      _selectedVendorIndex = null;
      _polylines.clear();
      // _distanceInKm = null;
      _isCardExpanded = false;
    });
  }

  void toggleVendorSelection(int index) {
    if (_selectedVendorIndex == index) {
      unselectVendor();
    } else {
      selectVendor(index);
    }
  }

  void addOrReplacePolyline(Polyline polyline) {
    setState(() {
      _polylines.removeWhere((p) => p.polylineId == polyline.polylineId);
      _polylines.add(polyline);
    });
  }

  void clearPolylines() {
    if (_polylines.isEmpty) return;
    setState(() {
      _polylines.clear();
      _isRouteSet = false;
    });
  }

  final Set<Marker> markers = {};
  //add markers
  Set<Marker> buildMarkers({BitmapDescriptor? customMarker}) {
    for (var i = 0; i < nearbyVendors.length; i++) {
      final vendor = nearbyVendors[i];
      if (vendor.lat != null && vendor.lng != null) {
        markers.add(
          Marker(
            markerId: MarkerId('vendor_$i'),
            position: LatLng(vendor.lat!, vendor.lng!),
            icon: customMarker ?? BitmapDescriptor.defaultMarker,
            onTap: () => toggleVendorSelection(i),
            infoWindow: InfoWindow(
              title: vendor.name,
              snippet: vendor.vendorType,
            ),
          ),
        );
      }
    }

    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: _userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    return markers;
  }

  // ----------------------------------------------------------------

  /// Main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: _selectedVendorIndex == null ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Visibility(
          visible: _selectedVendorIndex == null,
          child: FloatingActionButton(
            backgroundColor: context.colors.buttonPrimary,
            onPressed: () {
              _moveCameraToUser();
            },
            child: Icon(Icons.my_location_sharp, color: Colors.white),
          ),
        ),
      ),
      body: _assetsLoaded
          ? _buildMapStack()
          : const Center(child: LoadingWidget(color: Colors.white)),
    );
  }

  /// User avatar in AppBar
  Widget _buildUserAvatar() {
    return GestureDetector(
      onTap: () async {
        await unselectVendor();
        if (!mounted) return;
        UserProfileService.gotoUserProfile(context);
      },
      child: CircleAvatar(
        backgroundColor: context.colors.navBarBackground,
        radius: 25.r,
        child: CircleAvatar(
          radius: 23.r,
          backgroundColor: context.colors.primary,
          backgroundImage: user?.imageUrl != null
              ? NetworkImage(user!.imageUrl!)
              : null,
          child: user?.imageUrl != null
              ? null
              : Icon(Icons.person, color: Colors.white, size: 40.w),
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
              'Hey, ${user?.name}',
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
  Widget _buildMapStack() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          _buildGoogleMap(),
          Align(
            alignment: Alignment.topCenter,
            child: GradientOverlay(height: 250.h),
          ),
          _buildHeader(),
          // if (_distanceInKm != null && selectedVendor != null)
          //   _buildVendorProfileBox(),
          if (selectedVendor != null) _buildUserVendorCard(),
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 36.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
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
  Widget _buildGoogleMap() {
    return GoogleMap(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
      initialCameraPosition: CameraPosition(
        target: _userLocation ?? const LatLng(31.4645193, 74.2540502),
        zoom: 15,
      ),
      markers: buildMarkers(customMarker: _customMarker),
      polylines: polylines,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        if (!_controller.isCompleted) _controller.complete(controller);
        await Future.delayed(const Duration(milliseconds: 200));
        if (_mapStyle.isNotEmpty) controller.setMapStyle(_mapStyle);
      },
      onTap: (pos) {
        unselectVendor();
      },
    );
  }

  /// Search field at top
  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () {
        if (!_isUserLocationSet) {
          debugPrint('❌ USER LOCATION NOT SET');
          return;
        }
        openVendorSearch(
          userLocation: _userLocation!,
        ); // NEW: open search screen
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

  ///
  ///Updated
  ///
  Future<void> openVendorSearch({required LatLng userLocation}) async {
    //TODO: Add to service
    Navigator.pushNamed(
      context,
      RoutesName.userSearch,
      arguments: {
        'onVendorSelected': (VendorModel searchedVendor) async {
          //check if already in the list, update
          final bool vendorAlreadyLoaded = nearbyVendors.any(
            (v) => v.id == searchedVendor.id,
          );
          if (!vendorAlreadyLoaded) {
            debugPrint('Not loaded');
            //if not in list, add in the list
            nearbyVendors.add(searchedVendor);
            debugPrint('Added to list');

            // if location is null
            if (searchedVendor.lat == null || searchedVendor.lng == null) {
              debugPrint('Location does not found for this vendor.');
              final index = nearbyVendors.length - 1;
              selectVendor(index);
              return;
            }
            //create new marker
            markers.add(
              Marker(
                markerId: MarkerId('vendor_${searchedVendor.id}'),
                position: LatLng(searchedVendor.lat!, searchedVendor.lng!),
                icon: _customMarker ?? BitmapDescriptor.defaultMarker,
                // onTap: () => toggleVendorSelection(nearbyVendors.length - 1),
                onTap: () => toggleVendorSelection(
                  nearbyVendors.indexWhere((v) => v.id == searchedVendor.id),
                ),
                infoWindow: InfoWindow(
                  title: searchedVendor.name,
                  snippet: searchedVendor.vendorType,
                ),
              ),
            );
            debugPrint('Marker Added');
          }

          final index = nearbyVendors.indexWhere(
            (v) => v.id == searchedVendor.id,
          );
          if (index != -1) {
            selectVendor(index);
            debugPrint('VENDOR IS NOW SELECTED');
            // Move camera to selected vendor
            if (_userLocation != null &&
                nearbyVendors[index].lat != null &&
                nearbyVendors[index].lng != null) {
              debugPrint('DRAWING ROUTE');
              _drawRouteToVendor(
                LatLng(nearbyVendors[index].lat!, nearbyVendors[index].lng!),
                index,
              );
              debugPrint('ROUTE DRAWN NOW!');
            }
          }
        },
        'userLocation': userLocation,
      },
    );
  }

  /// Distance box displayed above vendor card
  // Widget _buildVendorProfileBox() {
  //   return Positioned(
  //     top: 480.h,
  //     left: 15.w,
  //     child: Material(
  //       elevation: 4,
  //       borderRadius: BorderRadius.circular(8.r),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(8.r),
  //         ),
  //         child: Text(
  //           'Distance: ${_distanceInKm!.toStringAsFixed(2)} km',
  //           style: TextStyle(
  //             color: Colors.black,
  //             fontSize: 14.sp,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// Vendor card displayed at bottom
  Widget _buildUserVendorCard() {
    final selected = selectedVendor;
    if (selected == null) return const SizedBox.shrink();
    return VendorCard(
      vendorId: selectedVendor!.id!,
      isExpanded: _isCardExpanded,
      isRouteSet: _isRouteSet,
      onTap: () async {
        if (!mounted) return;
        setState(() => _isCardExpanded = !_isCardExpanded);
      },
      distance: selected.distanceInKm ?? 0.0,
      vendorName: selected.name,
      imageUrl: selected.profileImage ?? '',
      vendorAddress: selected.address ?? '',
      vendorType: selected.vendorType,
      menuLength: selected.totalMenuItems ?? 0,
      hoursADay: selected.hoursADay != null
          ? selected.hoursADay.toString()
          : '0',
      onGetDirection: () async {
        if (selected.lat != null && selected.lng != null) {
          await _drawRouteToVendor(
            LatLng(selected.lat!, selected.lng!),
            _selectedVendorIndex ?? 0,
          );
          setState(() => _isCardExpanded = false);
        } else {
          context.flushBarErrorMessage(message: 'Location not Defined');
        }
      },
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
