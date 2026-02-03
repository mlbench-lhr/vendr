import 'dart:async';
import 'dart:math' as math;
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
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/location_service.dart';
import 'package:vendr/services/common/push_notifications_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/user/user_profile_service.dart';
import 'package:vendr/view/home/user/widgets/location_permission_required.dart';
import 'package:vendr/view/home/user/widgets/vendor_card.dart';

// ============================================================================
// CONFIGURATION
// ============================================================================

/// Adjust marker rotation based on your icon's default facing direction
/// 0 = North (UP), 90 = East (RIGHT), 180 = South (DOWN), 270 = West (LEFT)
const double _iconRotationOffset = 0.0;
const int _animationFrames = 60;

// ============================================================================
// MAIN SCREEN
// ============================================================================

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // ================= SERVICES ===============
  final _homeService = UserHomeService();
  final _locationService = VendorLocationService();
  final _session = SessionController();

  // ================= MAP ====================
  GoogleMapController? _mapController;
  late final PolylinePoints _polylinePoints;

  BitmapDescriptor? _staticMarker;
  BitmapDescriptor? _movingMarker;
  String _mapStyle = '';

  // ================= STATE ==================
  LatLng? _userLocation;
  bool _isLoading = true;
  late double _selectedDistanceKm; // Will be loaded from session

  int? _selectedIndex;
  final List<VendorModel> _vendors = [];
  final Set<Polyline> _polylines = {};
  bool _isRouteSet = false;
  bool _isCardExpanded = false;
  bool _isDrawingRoute = false;

  // ================= LIVE DATA ==============
  final Map<String, LatLng> _positions = {};
  final Map<String, double> _rotations = {};
  final Map<String, Timer> _animationTimers = {};

  StreamSubscription? _liveSubscription;

  // ================= LIFECYCLE ===============
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
    _liveSubscription = _locationService.onUpdate.listen(_onLiveUpdate);
  }

  @override
  void dispose() {
    _liveSubscription?.cancel();
    _locationService.stopListening();
    for (final timer in _animationTimers.values) {
      timer.cancel();
    }
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  // ================= INIT FLOW ===============
  Future<void> _initialize() async {
    _polylinePoints = PolylinePoints(apiKey: KeyConstants.googleApiKey);

    // Load saved distance filter preference
    _selectedDistanceKm = _session.distanceFilter;

    await _ensureLocationPermission();
    await _fetchUserLocation();
    await _loadAssets();
    await _fetchNearbyVendors();

    _locationService.startListening();

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _ensureLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await MyBottomSheet.show(
        context,
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        useSafeArea: false,
        child: const LocationPermissionRequired(),
      );
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      _userLocation = LatLng(position.latitude, position.longitude);
      _moveCameraToUser();

      PushNotificationsService().initFCM(
        // ignore: use_build_context_synchronously
        context: context,
        userLat: position.latitude,
        userLng: position.longitude,
      );
    } catch (_) {}
  }

  Future<void> _moveCameraToUser() async {
    if (_userLocation == null || !mounted) return;
    final controller = _mapController;
    if (controller == null) return;

    final zoom = _getZoomLevelForDistance(_selectedDistanceKm);

    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _userLocation!, zoom: zoom),
        ),
      );
    } catch (_) {
      // Controller might be disposed
    }
  }

  double _getZoomLevelForDistance(double distanceKm) {
    switch (distanceKm) {
      case 1.0:
        return 15.0;
      case 2.0:
        return 14.0;
      case 3.0:
        return 13.5;
      case 5.0:
        return 12.5;
      default:
        return 15.0;
    }
  }

  Future<void> _fetchNearbyVendors() async {
    final result = await _homeService.getNearbyVendors(
      context: context,
      location: _userLocation,
      maxDistance: _selectedDistanceKm, // Use dynamic distance
    );

    if (!mounted) return;

    // Filter vendors based on selected distance
    final filteredVendors = result.where((vendor) {
      if (vendor.distanceInKm == null) return true;
      return vendor.distanceInKm! <= _selectedDistanceKm;
    }).toList();

    _vendors
      ..clear()
      ..addAll(filteredVendors);

    for (final vendor in _vendors) {
      if (vendor.id != null && vendor.lat != null && vendor.lng != null) {
        _positions[vendor.id!] = LatLng(vendor.lat!, vendor.lng!);
        _rotations[vendor.id!] = 0;
      }
    }
  }

  // ================= DISTANCE FILTER =========
  bool _isChangingDistance =
      false; // Prevent multiple concurrent distance changes

  Future<void> _changeDistanceFilter(double newDistanceKm) async {
    if (_selectedDistanceKm == newDistanceKm) return;
    if (_isChangingDistance) return; // Prevent concurrent calls

    _isChangingDistance = true;

    setState(() {
      _selectedDistanceKm = newDistanceKm;
      _isLoading = true;
      _selectedIndex = null;
      _polylines.clear();
      _isRouteSet = false;
    });

    // Save the distance filter preference
    _session.saveDistanceFilter(newDistanceKm);

    try {
      await _fetchNearbyVendors().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('❌ Distance filter change timed out');
        },
      );

      // Update camera zoom based on new distance
      if (_userLocation != null && _mapController != null && mounted) {
        final zoom = _getZoomLevelForDistance(_selectedDistanceKm);
        try {
          await _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _userLocation!, zoom: zoom),
            ),
          );
        } catch (_) {
          // Controller might be disposed
        }
      }
    } catch (e) {
      debugPrint('❌ Error changing distance filter: $e');
    } finally {
      _isChangingDistance = false;
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= LIVE LOCATION ===========
  void _onLiveUpdate(dynamic _) {
    if (_userLocation == null || !mounted) return;

    final liveVendors = _locationService.getLiveVendorsNear(
      _userLocation!,
      _selectedDistanceKm, // Use dynamic distance
    );

    for (final vendor in liveVendors) {
      final id = vendor['vendorId'];
      final lat = vendor['latitude'];
      final lng = vendor['longitude'];

      if (id == null || lat == null || lng == null) continue;

      final newPosition = LatLng(lat.toDouble(), lng.toDouble());

      // Check if vendor is within selected distance
      final distance = _calculateDistance(
        _userLocation!.latitude,
        _userLocation!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance > _selectedDistanceKm) continue;

      final oldPosition = _positions[id];

      if (oldPosition == null) {
        _positions[id] = newPosition;
        _rotations[id] = 0;
        continue;
      }

      _animateMarker(id, oldPosition, newPosition);
    }

    // Also update vendors from list that are live
    for (final vendor in _vendors) {
      if (vendor.id == null) continue;
      if (!_locationService.isLive(vendor.id!)) continue;

      final lat = _locationService.getLat(vendor.id!);
      final lng = _locationService.getLng(vendor.id!);
      if (lat == null || lng == null) continue;

      final newPosition = LatLng(lat, lng);

      // Check if vendor is within selected distance
      final distance = _calculateDistance(
        _userLocation!.latitude,
        _userLocation!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance > _selectedDistanceKm) continue;

      final oldPosition = _positions[vendor.id!];

      if (oldPosition == null) {
        _positions[vendor.id!] = newPosition;
        _rotations[vendor.id!] = 0;
        continue;
      }

      if (_hasPositionChanged(oldPosition, newPosition)) {
        _animateMarker(vendor.id!, oldPosition, newPosition);
      }
    }

    if (mounted) setState(() {});
  }

  bool _hasPositionChanged(LatLng oldPos, LatLng newPos) {
    const threshold = 0.00001;
    return (oldPos.latitude - newPos.latitude).abs() > threshold ||
        (oldPos.longitude - newPos.longitude).abs() > threshold;
  }

  void _animateMarker(String id, LatLng from, LatLng to) {
    _animationTimers[id]?.cancel();

    final startRotation = _rotations[id] ?? 0;
    final endRotation = _calculateBearing(from, to);

    int frame = 0;
    _animationTimers[id] = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      frame++;
      final t = frame / _animationFrames;

      if (t >= 1) {
        _positions[id] = to;
        _rotations[id] = endRotation;
        timer.cancel();
        _animationTimers.remove(id);
        if (mounted) setState(() {});
        return;
      }

      final easedT = _easeInOutCubic(t);

      _positions[id] = LatLng(
        _lerp(from.latitude, to.latitude, easedT),
        _lerp(from.longitude, to.longitude, easedT),
      );

      double delta = endRotation - startRotation;
      while (delta > 180) {
        delta -= 360;
      }
      while (delta < -180) {
        delta += 360;
      }

      _rotations[id] = (startRotation + delta * easedT + 360) % 360;
      if (mounted) setState(() {});
    });
  }

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3.0) / 2;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  // ================= MARKERS =================
  Set<Marker> _buildMarkers() {
    final Set<Marker> markers = {};
    final liveVendorIds = _getLiveVendorIds();

    for (final vendor in _vendors) {
      if (vendor.id == null) continue;

      final position = _positions[vendor.id!];
      if (position == null) continue;

      // Check if vendor is within selected distance
      if (_userLocation != null) {
        final distance = _calculateDistance(
          _userLocation!.latitude,
          _userLocation!.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance > _selectedDistanceKm) continue;
      }

      final isLive =
          liveVendorIds.contains(vendor.id) ||
          _locationService.isLive(vendor.id!);

      markers.add(
        Marker(
          markerId: MarkerId(vendor.id!),
          position: position,
          icon: isLive
              ? (_movingMarker ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ))
              : (_staticMarker ?? BitmapDescriptor.defaultMarker),
          rotation: isLive ? (_rotations[vendor.id!] ?? 0) : 0,
          flat: isLive,
          zIndex: isLive ? 2.0 : 1.0,
          anchor: const Offset(0.5, 0.5),
          onTap: () => setState(() {
            _selectedIndex = _vendors.indexOf(vendor);
          }),
          infoWindow: InfoWindow(
            title: vendor.name,
            snippet: vendor.vendorType,
          ),
        ),
      );
    }

    // Add live vendors not in list
    if (_userLocation != null) {
      final liveVendors = _locationService.getLiveVendorsNear(
        _userLocation!,
        _selectedDistanceKm, // Use dynamic distance
      );

      for (final vendor in liveVendors) {
        final id = vendor['vendorId'] as String?;
        if (id == null || id.isEmpty) continue;
        if (_vendors.any((v) => v.id == id)) continue;

        final position = _positions[id];
        final lat =
            position?.latitude ?? (vendor['latitude'] as num?)?.toDouble();
        final lng =
            position?.longitude ?? (vendor['longitude'] as num?)?.toDouble();

        if (lat == null || lng == null) continue;

        // Check if vendor is within selected distance
        final distance = _calculateDistance(
          _userLocation!.latitude,
          _userLocation!.longitude,
          lat,
          lng,
        );

        if (distance > _selectedDistanceKm) continue;

        markers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            icon:
                _movingMarker ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
            rotation: _rotations[id] ?? 0,
            flat: true,
            zIndex: 2.0,
            anchor: const Offset(0.5, 0.5),
            onTap: () => setState(() {
              _selectedIndex = null;
            }),
            infoWindow: InfoWindow(
              title: vendor['name'] ?? 'Unknown',
              snippet: vendor['vendorType'] ?? '',
            ),
          ),
        );
      }
    }

    return markers;
  }

  Set<String> _getLiveVendorIds() {
    if (_userLocation == null) return {};
    return _locationService
        .getLiveVendorsNear(
          _userLocation!,
          _selectedDistanceKm,
        ) // Use dynamic distance
        .where((v) => (v['vendorId'] as String?)!.isNotEmpty)
        .map((v) => v['vendorId'] as String)
        .toSet();
  }

  // ================= ROUTE ===================
  Future<void> _drawRouteToVendor(LatLng destination, int index) async {
    if (_isDrawingRoute || !mounted) return;

    if (_isRouteSet) {
      setState(() {
        _polylines.clear();
        _isRouteSet = false;
      });
      return;
    }

    final user = _userLocation;
    if (user == null) {
      final controller = _mapController;
      if (controller == null || !mounted) return;
      try {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(destination, 15),
        );
      } catch (_) {
        // Controller might be disposed
      }
      setState(() => _selectedIndex = index);
      return;
    }

    _isDrawingRoute = true;

    try {
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(user.latitude, user.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (!mounted) return;

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route_$index'),
            points: result.points.isEmpty
                ? [user, destination]
                : result.points
                      .map((p) => LatLng(p.latitude, p.longitude))
                      .toList(),
            width: 5,
            color: result.points.isEmpty ? Colors.grey : Colors.blue,
            patterns: result.points.isEmpty
                ? [PatternItem.dash(10), PatternItem.gap(6)]
                : [],
          ),
        );
        _isRouteSet = true;
      });

      _fitBounds(user, destination);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('fallback_$index'),
            points: [user, destination],
            width: 3,
            color: Colors.grey,
            patterns: [PatternItem.dash(10), PatternItem.gap(6)],
          ),
        );
        _isRouteSet = true;
      });
    } finally {
      _isDrawingRoute = false;
    }
  }

  void _fitBounds(LatLng user, LatLng vendor) async {
    if (!mounted) return;
    final controller = _mapController;
    if (controller == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(user.latitude, vendor.latitude),
        math.min(user.longitude, vendor.longitude),
      ),
      northeast: LatLng(
        math.max(user.latitude, vendor.latitude),
        math.max(user.longitude, vendor.longitude),
      ),
    );

    try {
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (_) {
      // Controller might be disposed
    }
  }

  // ================= BEARING =================
  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180.0;
    final lat2 = to.latitude * math.pi / 180.0;
    final lon1 = from.longitude * math.pi / 180.0;
    final lon2 = to.longitude * math.pi / 180.0;
    final dLon = lon2 - lon1;

    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x) * 180.0 / math.pi;
    bearing = (bearing + 360) % 360;
    return (bearing + _iconRotationOffset) % 360;
  }

  // ================= ASSETS ==================
  Future<void> _loadAssets() async {
    try {
      _mapStyle = await rootBundle.loadString(Assets.json.mapStyles.nightTheme);
    } catch (_) {}

    _staticMarker = await _loadMarker(
      Assets.images.shopMarker.path,
      const Color(0xFF21242B),
      false,
    );
    _movingMarker = await _loadMarker(
      Assets.images.truck.path,
      const Color(0xFF21242B),
      true,
    );
  }

  Future<BitmapDescriptor> _loadMarker(
    String assetPath,
    Color backgroundColor,
    bool hasBorder,
  ) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      const circleSize = 100.0;
      const imageSize = 60.0;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final center = circleSize / 2;

      // Background
      canvas.drawCircle(
        Offset(center, center),
        center,
        Paint()..color = backgroundColor,
      );

      // Border for moving markers
      if (hasBorder) {
        canvas.drawCircle(
          Offset(center, center),
          center - 2,
          Paint()
            ..color = const Color(0xFF4CAF50)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }

      // Draw image
      final src = Rect.fromLTWH(
        0,
        0,
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
      final dst = Rect.fromLTWH(
        (circleSize - imageSize) / 2,
        (circleSize - imageSize) / 2,
        imageSize,
        imageSize,
      );
      canvas.drawImageRect(frame.image, src, dst, Paint());

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        circleSize.toInt(),
        circleSize.toInt(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (_) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  // ================= UI ======================
  @override
  Widget build(BuildContext context) {
    if (_isLoading || _userLocation == null) {
      return const Scaffold(
        body: Center(child: LoadingWidget(color: Colors.white)),
      );
    }

    return Scaffold(
      floatingActionButton: _selectedIndex == null
          ? FloatingActionButton(
              backgroundColor: context.colors.buttonPrimary,
              onPressed: _moveCameraToUser,
              child: const Icon(Icons.my_location_sharp, color: Colors.white),
            )
          : null,
      body: _buildMapStack(),
    );
  }

  Widget _buildMapStack() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          _buildGoogleMap(),
          Align(alignment: Alignment.topCenter, child: _buildGradientOverlay()),
          _buildHeader(),
          if (_selectedIndex != null) _buildVendorCard(),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      height: 250.h,
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

  Widget _buildGoogleMap() {
    final zoom = _getZoomLevelForDistance(_selectedDistanceKm);

    return GoogleMap(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
      initialCameraPosition: CameraPosition(target: _userLocation!, zoom: zoom),
      markers: _buildMarkers(),
      polylines: _polylines,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        _mapController = controller;
        await Future.delayed(const Duration(milliseconds: 200));
        if (_mapStyle.isNotEmpty && mounted) {
          try {
            await controller.setMapStyle(_mapStyle);
          } catch (_) {
            // Map style setting failed
          }
        }
      },
      onTap: (_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = null;
          _polylines.clear();
          _isRouteSet = false;
        });
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 36.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildUserAvatar(),
              SizedBox(width: 10.w),
              _buildUserGreeting(),
              const Spacer(),
              _buildNotificationsBtn(),
            ],
          ),
          20.height,
          _buildSearchField(),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDistanceContainer('1', 1.0),
              _buildDistanceContainer('2', 2.0),
              _buildDistanceContainer('3', 3.0),
              _buildDistanceContainer('5', 5.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return GestureDetector(
      onTap: () async {
        setState(() => _selectedIndex = null);
        if (mounted) UserProfileService.gotoUserProfile(context);
      },
      child: Stack(
        children: [
          CircleAvatar(
            // backgroundColor: context.colors.navBarBackground,
            backgroundColor: Colors.blue,
            radius: 24.r,
            child: CircleAvatar(
              radius: 23.r,
              backgroundColor: context.colors.primary,
              backgroundImage: _session.user?.imageUrl != null
                  ? NetworkImage(_session.user!.imageUrl!)
                  : null,
              child: _session.user?.imageUrl == null
                  ? Icon(Icons.person, color: Colors.white, size: 40.w)
                  : null,
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Icon(Icons.account_circle, size: 12.2, color: Colors.blue),
          ),
        ],
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
              'Hey, ${_session.user?.name}',
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

  Widget _buildNotificationsBtn() {
    return GestureDetector(
      onTap: () => UserHomeService.gotoNotifications(context),
      child: const Icon(Icons.notifications_outlined, size: 28),
    );
  }

  Widget _buildDistanceContainer(String label, double distanceKm) {
    final bool isSelected = _selectedDistanceKm == distanceKm;

    return GestureDetector(
      onTap: () => _changeDistanceFilter(distanceKm),
      child: Card(
        color: isSelected ? Colors.blue : const Color(0xff2E323D),
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Center(
            child: Text(
              '$label km',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: _userLocation != null ? _openVendorSearch : null,
      child: AbsorbPointer(
        child: MyTextField(
          borderRadius: 40.r,
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hint: 'Search Vendors',
        ),
      ),
    );
  }

  Future<void> _openVendorSearch() async {
    Navigator.pushNamed(
      context,
      RoutesName.userSearch,
      arguments: {
        'onVendorSelected': (VendorModel vendor) async {
          if (!_vendors.any((v) => v.id == vendor.id)) {
            _vendors.add(vendor);
            if (vendor.lat != null && vendor.lng != null) {
              _positions[vendor.id!] = LatLng(vendor.lat!, vendor.lng!);
              _rotations[vendor.id!] = 0;
            }
          }

          final index = _vendors.indexWhere((v) => v.id == vendor.id);
          if (index != -1) {
            setState(() => _selectedIndex = index);

            final position = _positions[vendor.id!];
            if (position != null && _userLocation != null) {
              await _drawRouteToVendor(position, index);
            }
          }
        },
        'userLocation': _userLocation,
      },
    );
  }

  Widget _buildVendorCard() {
    final vendor = _vendors[_selectedIndex!];
    final position = _positions[vendor.id!];
    final lat = position?.latitude ?? vendor.lat;
    final lng = position?.longitude ?? vendor.lng;

    double distance = vendor.distanceInKm ?? 0.0;
    if (_locationService.isLive(vendor.id!) &&
        _userLocation != null &&
        lat != null &&
        lng != null) {
      distance = _calculateDistance(
        _userLocation!.latitude,
        _userLocation!.longitude,
        lat,
        lng,
      );
    }

    return VendorCard(
      vendorId: vendor.id!,
      vendorName: vendor.name,
      vendorType: vendor.vendorType,
      imageUrl: vendor.profileImage ?? '',
      vendorAddress: vendor.address ?? '',
      distance: _roundToOneDecimal(distance),
      menuLength: vendor.totalMenuItems ?? 0,
      hoursADay: vendor.hoursADay?.toString() ?? '0',
      isExpanded: _isCardExpanded,
      isRouteSet: _isRouteSet,
      hasPermit: vendor.hasPermit ?? false,
      onTap: () => setState(() => _isCardExpanded = !_isCardExpanded),
      onGetDirection: lat != null && lng != null
          ? () async {
              await _drawRouteToVendor(LatLng(lat, lng), _selectedIndex!);
              if (mounted) setState(() => _isCardExpanded = false);
            }
          : null,
    );
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLng = (lng2 - lng1) * math.pi / 180.0;
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _roundToOneDecimal(double value) =>
      double.parse(value.toStringAsFixed(1));
}
