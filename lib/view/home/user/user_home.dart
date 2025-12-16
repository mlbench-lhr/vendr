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
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/view/home/user/user_search.dart';
import 'package:vendr/view/home/user/widgets/location_permission_required.dart';
import 'package:vendr/view/home/user/widgets/vendor_card.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';

/// Initial vendor list (as provided)
final List<VendorModel> initialVendors = [
  VendorModel(
    name: 'Harry Brook',
    address: '15 Maiden Ln Suite 908, New York, NY 10038',
    location: LatLng(31.50293, 74.34801),
    phone: '09876542',
    email: 'harry@brook.com',
    vendorType: 'Food vendor',
    menu: [
      MenuItemModel(
        itemName: 'First Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Second Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Third Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
    ],
    hoursADay: '10 Hours',
    profileImage:
        'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=80',
    id: '1Herry',
  ),
  VendorModel(
    name: 'Emma Stone',
    email: 'emma@stone.com',
    phone: '09876542',
    address: '22 Broadway, New York, NY 10007',
    location: LatLng(31.46719, 74.26598),
    vendorType: 'Grocery vendor',
    menu: [
      MenuItemModel(
        itemName: 'First Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Second Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
    ],
    hoursADay: '10 Hours',
    profileImage:
        'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0',
    id: '',
  ),
  VendorModel(
    name: 'Tom Hanks',
    address: '34 Wall Street, New York, NY 10005',
    location: LatLng(31.47124, 74.35593),
    vendorType: 'Electronics vendor',
    phone: '09876542',
    email: 'tom@hank.com',
    menu: [
      MenuItemModel(
        itemName: 'First Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Second Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Third Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Fourth Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Fifth Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
    ],
    hoursADay: '10 Hours',
    profileImage:
        'https://images.unsplash.com/photo-1519520104014-df63821cb6f9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0',
    id: '2Tom',
  ),
  VendorModel(
    name: 'Sophia Lee',
    address: '10 Park Ave, New York, NY 10016',
    location: LatLng(31.450, 74.310),
    vendorType: 'Clothing vendor',
    phone: '09876542',
    email: 'sophia@lee.com',
    menu: [
      MenuItemModel(
        itemName: 'First Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Second Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Third Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Fourth Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Fifth Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Sixth Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
      MenuItemModel(
        itemName: 'Seventh Item',
        servings: [
          ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$73'),
        ],
      ),
    ],
    hoursADay: '10 Hours',
    profileImage:
        'https://images.unsplash.com/photo-1762844877991-54c007866283?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0',
    id: '3Heerry',
  ),
];

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
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
  double? _distanceInKm;
  bool _isCardExpanded = false;

  // ----- Replaced Provider state (moved here) -----
  final List<VendorModel> vendors = List<VendorModel>.from(initialVendors);
  LatLng? _userLocation;
  int? _selectedVendorIndex;
  final Set<Polyline> _polylines = {};

  VendorModel? get selectedVendor =>
      (_selectedVendorIndex != null) ? vendors[_selectedVendorIndex!] : null;
  Set<Polyline> get polylines => Set.unmodifiable(_polylines);

  // -----------------------------------------------

  @override
  void initState() {
    sessionController.addListener(_onSessionChanged);
    super.initState();
    checkLocationPermission();
    _loadAssets();
    _polylinePoints = PolylinePoints(apiKey: KeyConstants.googleApiKey);

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
        child: const LocationPermissionRequired(),
      );
      checkLocationPermission();
    }
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
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

      updateUserLocation(LatLng(position.latitude, position.longitude));

      _moveCameraToUser();
    } catch (e) {
      debugPrint('Error while fetching location: $e');
    }
  }

  /// Move camera to user's current location
  Future<void> _moveCameraToUser() async {
    if (_userLocation == null) return;

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
    });
  }

  void selectVendor(int index) {
    if (index < 0 || index >= vendors.length) return;
    if (_selectedVendorIndex == index) return;
    setState(() {
      _selectedVendorIndex = index;
    });
  }

  void unselectVendor() {
    if (_selectedVendorIndex == null && _polylines.isEmpty) return;
    setState(() {
      _selectedVendorIndex = null;
      _polylines.clear();
      _distanceInKm = null;
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
    });
  }

  Set<Marker> buildMarkers({BitmapDescriptor? customMarker}) {
    final Set<Marker> markers = {};

    for (var i = 0; i < vendors.length; i++) {
      final vendor = vendors[i];
      if (vendor.location != null) {
        markers.add(
          Marker(
            markerId: MarkerId('vendor_$i'),
            position: vendor.location!,
            icon: customMarker ?? BitmapDescriptor.defaultMarker,
            onTap: () => toggleVendorSelection(i),
            infoWindow: InfoWindow(title: vendor.name),
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
      onTap: () {
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
          if (_distanceInKm != null && selectedVendor != null)
            _buildVendorProfileBox(),
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
        zoom: 14.4,
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
        openVendorSearch(); // NEW: open search screen
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

  /// Open User Search Screen and handle selected vendor
  Future<void> openVendorSearch() async {
    Navigator.pushNamed(
      context,
      RoutesName.userSearch,
      arguments: {
        'onVendorSelected': (VendorModel vendor) {
          final index = vendors.indexWhere((v) => v.id == vendor.id);
          if (index != -1) {
            selectVendor(index);

            // Move camera to selected vendor
            if (_userLocation != null && vendors[index].location != null) {
              _drawRouteToVendor(vendors[index].location!, index);
            }
          }
        },
      },
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
  Widget _buildUserVendorCard() {
    final selected = selectedVendor;
    if (selected == null) return const SizedBox.shrink();

    return VendorCard(
      isExpanded: _isCardExpanded,
      onTap: () => setState(() => _isCardExpanded = !_isCardExpanded),
      distance: _distanceInKm ?? 0.0,
      vendorName: selected.name,
      imageUrl: selected.profileImage ?? '',
      vendorAddress: selected.address ?? '',
      vendorType: selected.vendorType,
      menu: selected.menu ?? [],
      hoursADay: selected.hoursADay ?? '',
      onGetDirection: () async {
        if (selected.location != null) {
          await _drawRouteToVendor(
            selected.location!,
            _selectedVendorIndex ?? 0,
          );
          setState(() => _isCardExpanded = false);
        } else {
          context.flushBarErrorMessage(message: 'Location not Defined');
        }
      },
      vendorId: selectedVendor!.id!,
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
