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
import 'package:vendr/services/common/location_service.dart';
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

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _userHomeService = UserHomeService();
  final _locationService = VendorLocationService();
  StreamSubscription? _liveSub;

  final Completer<GoogleMapController> _controller = Completer();
  late final PolylinePoints _polylinePoints;

  final sessionController = SessionController();
  UserModel? get user => SessionController().user;

  BitmapDescriptor? _customMarker;
  BitmapDescriptor? _movingMarker;

  String _mapStyle = '';
  bool _assetsLoaded = false;

  bool _isCardExpanded = false;
  bool _isRouteSet = false;
  bool _isUserLocationSet = false;
  bool _isNearbyVendorsLoaded = false;
  bool _isInitializingLocation = false;

  List<VendorModel> nearbyVendors = [];
  LatLng? _userLocation;
  int? _selectedVendorIndex;
  Map<String, dynamic>? _selectedLiveVendor;
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

    _liveSub = _locationService.onUpdate.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    sessionController.removeListener(_onSessionChanged);
    _liveSub?.cancel();
    _locationService.stopListening();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    _polylinePoints = PolylinePoints(apiKey: KeyConstants.googleApiKey);
    await _initializeUserLocation();
  }

  Future<void> _initializeUserLocation() async {
    if (_isInitializingLocation || _isNearbyVendorsLoaded) return;
    _isInitializingLocation = true;
    try {
      await checkLocationPermission();
      await _getUserLocation();
      if (!mounted) return;
      setState(() {
        _isNearbyVendorsLoaded = true;
      });
      _locationService.startListening();
      await getNearbyVendors();
      await _loadAssets();
    } finally {
      _isInitializingLocation = false;
    }
  }

  Future<void> getNearbyVendors() async {
    setState(() {
      _isNearbyVendorsLoaded = true;
    });
    final List<VendorModel> vendorsResponse = await _userHomeService
        .getNearbyVendors(
          context: context,
          location: _userLocation,
          maxDistance: 5,
        );
    if (!mounted) return;
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
    if (!mounted) return;
    setState(() => _locationPermissionStatus = status);
    permissionGranted =
        _locationPermissionStatus == LocationPermission.always ||
        _locationPermissionStatus == LocationPermission.whileInUse;

    debugPrint('Location Status: $permissionGranted');
    if (!permissionGranted) {
      await _showLocationPermissionSheet();
    }
    // Removed: else { _initializeUserLocation(); }
  }

  Future<void> _showLocationPermissionSheet() async {
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

  Future<void> _loadAssets() async {
    await _loadMapStyle();
    await _loadCustomMarker();
    await _loadMovingMarker();
    if (!mounted) return;
    setState(() => _assetsLoaded = true);
  }

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

      canvas.drawCircle(
        Offset(circleSize / 2, circleSize / 2),
        circleSize / 2,
        paint..color = const Color(0xFF21242B),
      );

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

  Future<void> _loadMovingMarker({
    double circleSize = 100,
    double imageSize = 60,
  }) async {
    try {
      final data = await rootBundle.load(Assets.images.truck.path);
      final bytes = data.buffer.asUint8List();

      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      canvas.drawCircle(
        Offset(circleSize / 2, circleSize / 2),
        circleSize / 2,
        paint..color = const Color(0xFF4CAF50),
      );

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

      _movingMarker = BitmapDescriptor.fromBytes(
        byteData!.buffer.asUint8List(),
      );
    } catch (e) {
      debugPrint('Could not load moving marker: $e');
    }
  }

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

      if (context.mounted) {
        PushNotificationsService().initFCM(
          context: context,
          userLat: _userLocation!.latitude,
          userLng: _userLocation!.longitude,
        );
      }
    } catch (e) {
      debugPrint('Error while fetching location: $e');
    }
  }

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

  Future<void> _drawRouteToVendor(LatLng vendor, int index) async {
    debugPrint('_isDirectionSet $_isRouteSet');
    if (_isRouteSet) {
      clearPolylines();
      return;
    }
    if (!mounted) return;
    setState(() {
      _isRouteSet = true;
    });

    final user = _userLocation;
    if (user == null) {
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
      selectVendor(index);
      return;
    }

    clearPolylines();

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
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
    } catch (e) {
      debugPrint('Error creating route: $e');
    }
  }

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

  void updateUserLocation(LatLng newLocation) {
    if (_userLocation == newLocation) return;
    if (!mounted) return;
    setState(() {
      _userLocation = newLocation;
      _isUserLocationSet = true;
    });
  }

  void selectVendor(int index) {
    if (index < 0 || index >= nearbyVendors.length) return;
    if (_selectedVendorIndex == index) return;
    if (!mounted) return;
    setState(() {
      _selectedVendorIndex = index;
      _selectedLiveVendor = null;
    });
  }

  Future<void> unselectVendor() async {
    if (_selectedVendorIndex == null &&
        _selectedLiveVendor == null &&
        _polylines.isEmpty)
      return;
    if (!mounted) return;
    setState(() {
      _selectedVendorIndex = null;
      _selectedLiveVendor = null;
      _polylines.clear();
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
    if (!mounted) return;
    setState(() {
      _polylines.removeWhere((p) => p.polylineId == polyline.polylineId);
      _polylines.add(polyline);
    });
  }

  void clearPolylines() {
    if (_polylines.isEmpty) return;
    if (!mounted) return;
    setState(() {
      _polylines.clear();
      _isRouteSet = false;
    });
  }

  /// Build markers with priority: Live > Fixed
  /// Builds all markers for the map.
  /// Priority: Live vendor location > Fixed vendor location.
  /// Small card and info window display only vendor name and type.
  Set<Marker> buildMarkers({BitmapDescriptor? customMarker}) {
    final Set<Marker> markers = {};
    final Set<String> liveVendorIds = {};

    // Collect all live vendor IDs near the user
    if (_userLocation != null) {
      final liveVendors = _locationService.getLiveVendorsNear(
        _userLocation!,
        5,
      );
      for (final lv in liveVendors) {
        final id = lv['vendorId'] as String? ?? '';
        if (id.isNotEmpty) liveVendorIds.add(id);
      }
    }

    // Add backend vendors (fixed)
    for (var i = 0; i < nearbyVendors.length; i++) {
      final vendor = nearbyVendors[i];
      if (vendor.id == null) continue;

      double? lat;
      double? lng;
      BitmapDescriptor icon;

      // Use live location if available, otherwise fixed backend location
      if (liveVendorIds.contains(vendor.id)) {
        lat = _locationService.getLat(vendor.id!);
        lng = _locationService.getLng(vendor.id!);
        icon =
            _movingMarker ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else {
        lat = vendor.lat;
        lng = vendor.lng;
        icon = customMarker ?? BitmapDescriptor.defaultMarker;
      }

      if (lat == null || lng == null) continue;

      markers.add(
        Marker(
          markerId: MarkerId(vendor.id!),
          position: LatLng(lat, lng),
          icon: icon,
          onTap: () => toggleVendorSelection(i),
          infoWindow: InfoWindow(
            title: vendor.name,
            snippet: vendor.vendorType, // Only show name + type
          ),
        ),
      );
    }

    // Add live-only vendors (not in backend list)
    if (_userLocation != null) {
      final liveVendors = _locationService.getLiveVendorsNear(
        _userLocation!,
        5,
      );
      for (final lv in liveVendors) {
        final id = lv['vendorId'] as String? ?? '';
        if (id.isEmpty) continue;

        // Skip if already added from backend
        if (nearbyVendors.any((v) => v.id == id)) continue;

        final lat = (lv['latitude'] as num?)?.toDouble();
        final lng = (lv['longitude'] as num?)?.toDouble();
        if (lat == null || lng == null) continue;

        markers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            icon:
                _movingMarker ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
            onTap: () {
              setState(() {
                _selectedLiveVendor = lv;
                _selectedVendorIndex = null;
              });
            },
            infoWindow: InfoWindow(
              title: lv['name'] ?? 'Unknown',
              snippet: lv['vendorType'] ?? '',
            ),
          ),
        );
      }
    }

    // Add user marker
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: (_selectedVendorIndex == null && _selectedLiveVendor == null)
            ? 1.0
            : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Visibility(
          visible: _selectedVendorIndex == null && _selectedLiveVendor == null,
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

  Widget _buildMapStack() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          Center(child: LoadingWidget(color: Colors.white70)),
          _buildGoogleMap(),
          Align(
            alignment: Alignment.topCenter,
            child: GradientOverlay(height: 250.h),
          ),
          _buildHeader(),
          if (selectedVendor != null || _selectedLiveVendor != null)
            _buildUserVendorCard(),
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

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () {
        if (!_isUserLocationSet) {
          debugPrint('❌ USER LOCATION NOT SET');
          return;
        }
        openVendorSearch(userLocation: _userLocation!);
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

  Future<void> openVendorSearch({required LatLng userLocation}) async {
    Navigator.pushNamed(
      context,
      RoutesName.userSearch,
      arguments: {
        'onVendorSelected': (VendorModel searchedVendor) async {
          final bool vendorAlreadyLoaded = nearbyVendors.any(
            (v) => v.id == searchedVendor.id,
          );
          if (!vendorAlreadyLoaded) {
            debugPrint('Not loaded');
            nearbyVendors.add(searchedVendor);
            debugPrint('Added to list');
          }

          final index = nearbyVendors.indexWhere(
            (v) => v.id == searchedVendor.id,
          );
          if (index != -1) {
            selectVendor(index);
            debugPrint('VENDOR IS NOW SELECTED');

            double? lat;
            double? lng;
            if (_locationService.isLive(searchedVendor.id!)) {
              lat = _locationService.getLat(searchedVendor.id!);
              lng = _locationService.getLng(searchedVendor.id!);
            } else {
              lat = searchedVendor.lat;
              lng = searchedVendor.lng;
            }

            if (_userLocation != null && lat != null && lng != null) {
              debugPrint('DRAWING ROUTE');
              _drawRouteToVendor(LatLng(lat, lng), index);
              debugPrint('ROUTE DRAWN NOW!');
            }
          }
        },
        'userLocation': userLocation,
      },
    );
  }

  Widget _buildUserVendorCard() {
    // Live-only vendor
    if (_selectedLiveVendor != null) {
      final lv = _selectedLiveVendor!;
      return VendorCard(
        vendorId: lv['vendorId'] ?? '',
        isExpanded: _isCardExpanded,
        isRouteSet: _isRouteSet,
        onTap: () async {
          if (!mounted) return;
          setState(() => _isCardExpanded = !_isCardExpanded);
        },
        distance: 0,
        vendorName: lv['name'] ?? '',
        imageUrl: lv['profileImage'] ?? '',
        vendorAddress: '',
        vendorType: lv['vendorType'] ?? '',
        menuLength: lv['menuCount'] ?? 0,
        hoursADay: (lv['hoursADay'] ?? 0).toString(),
        onGetDirection: () async {
          final lat = (lv['latitude'] as num).toDouble();
          final lng = (lv['longitude'] as num).toDouble();
          await _drawRouteToVendor(LatLng(lat, lng), 0);
          if (!mounted) return;
          setState(() => _isCardExpanded = false);
        },
      );
    }

    // Backend vendor
    final selected = selectedVendor;
    if (selected == null) return const SizedBox.shrink();

    double? lat = selected.lat;
    double? lng = selected.lng;
    if (_locationService.isLive(selected.id!)) {
      lat = _locationService.getLat(selected.id!);
      lng = _locationService.getLng(selected.id!);
    }

    return VendorCard(
      vendorId: selected.id!,
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
        if (lat != null && lng != null) {
          await _drawRouteToVendor(LatLng(lat, lng), _selectedVendorIndex ?? 0);
          if (!mounted) return;
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
          colors: [Colors.white30, Colors.transparent],
        ),
      ),
    );
  }
}
