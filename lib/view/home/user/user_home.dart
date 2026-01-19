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
import 'package:vendr/view/home/user/widgets/user_location_marker.dart';
import 'package:vendr/view/home/user/widgets/vendor_card.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // ============================================================
  // CONFIGURATION - Adjust these values if marker direction is wrong
  // ============================================================

  /// Offset to adjust marker rotation direction
  /// Try these values if marker faces wrong direction:
  /// - 0: Icon faces UP (North) by default
  /// - 90: Icon faces RIGHT (East) by default
  /// - 180: Icon faces DOWN (South) by default
  /// - 270 or -90: Icon faces LEFT (West) by default
  static const double _iconRotationOffset =
      180.0; // CHANGED: Add 180° to flip direction

  final _userHomeService = UserHomeService();
  final _locationService = VendorLocationService();
  StreamSubscription? _liveSub;

  final Completer<GoogleMapController> _controller = Completer();
  late final PolylinePoints _polylinePoints;

  final sessionController = SessionController();
  UserModel? get user => SessionController().user;

  final Map<String, LatLng> _animatedPositions = {};
  final Map<String, Timer> _markerTimers = {};
  final Map<String, LatLng> _lastKnownPositions = {};
  final Map<String, double> _markerRotations = {};
  final Map<String, double> _targetRotations = {};

  BitmapDescriptor? _customMarker;
  BitmapDescriptor? _movingMarker;

  String _mapStyle = '';
  bool _assetsLoaded = false;
  bool _isCardExpanded = false;
  bool _isRouteSet = false;
  bool _isDrawingRoute = false;
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

  bool permissionGranted = false;
  LocationPermission _locationPermissionStatus = LocationPermission.denied;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeMap());
    _liveSub = _locationService.onUpdate.listen((_) {
      if (mounted) _handleLiveLocationUpdate();
    });
  }

  @override
  void dispose() {
    _liveSub?.cancel();
    _locationService.stopListening();
    for (final timer in _markerTimers.values) {
      timer.cancel();
    }
    _markerTimers.clear();
    _animatedPositions.clear();
    _lastKnownPositions.clear();
    _markerRotations.clear();
    _targetRotations.clear();
    super.dispose();
  }

  // ============================================================
  // BEARING & ROTATION CALCULATIONS - FIXED
  // ============================================================

  /// Calculates bearing from one point to another
  /// Returns degrees clockwise from North (0-360)
  /// Applies rotation offset to match icon's default facing direction
  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * math.pi / 180.0;
    final double lat2 = to.latitude * math.pi / 180.0;
    final double lon1 = from.longitude * math.pi / 180.0;
    final double lon2 = to.longitude * math.pi / 180.0;
    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x) * 180.0 / math.pi;

    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    // Apply rotation offset to correct icon direction
    bearing = (bearing + _iconRotationOffset) % 360;

    return bearing;
  }

  double _normalizeRotationDelta(double from, double to) {
    double delta = to - from;
    while (delta > 180) delta -= 360;
    while (delta < -180) delta += 360;
    return delta;
  }

  double _getMarkerRotation(String vendorId) {
    return _markerRotations[vendorId] ?? 0.0;
  }

  double _roundToOneDecimal(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  // ============================================================
  // LIVE LOCATION UPDATES
  // ============================================================

  void _handleLiveLocationUpdate() {
    if (_userLocation == null) return;

    final liveVendors = _locationService.getLiveVendorsNear(_userLocation!, 5);

    for (final lv in liveVendors) {
      final vendorId = lv['vendorId'] as String? ?? '';
      if (vendorId.isEmpty) continue;

      final newLat = (lv['latitude'] as num?)?.toDouble();
      final newLng = (lv['longitude'] as num?)?.toDouble();

      if (newLat == null || newLng == null) continue;

      final newPosition = LatLng(newLat, newLng);
      final oldPosition =
          _animatedPositions[vendorId] ?? _lastKnownPositions[vendorId];

      if (oldPosition == null) {
        _animatedPositions[vendorId] = newPosition;
        _lastKnownPositions[vendorId] = newPosition;
        _markerRotations[vendorId] = 0.0;
        continue;
      }

      if (_hasPositionChanged(oldPosition, newPosition)) {
        final newBearing = _calculateBearing(oldPosition, newPosition);
        _targetRotations[vendorId] = newBearing;
        _lastKnownPositions[vendorId] = newPosition;

        _animateMarkerSmoothly(
          vendorId: vendorId,
          from: oldPosition,
          to: newPosition,
        );
      }
    }

    // Also update nearby vendors that are live
    for (final vendor in nearbyVendors) {
      if (vendor.id == null) continue;

      if (_locationService.isLive(vendor.id!)) {
        final liveLat = _locationService.getLat(vendor.id!);
        final liveLng = _locationService.getLng(vendor.id!);

        if (liveLat == null || liveLng == null) continue;

        final newPosition = LatLng(liveLat, liveLng);
        final oldPosition =
            _animatedPositions[vendor.id!] ?? _lastKnownPositions[vendor.id!];

        if (oldPosition == null) {
          _animatedPositions[vendor.id!] = newPosition;
          _lastKnownPositions[vendor.id!] = newPosition;
          _markerRotations[vendor.id!] = 0.0;
          continue;
        }

        if (_hasPositionChanged(oldPosition, newPosition)) {
          final newBearing = _calculateBearing(oldPosition, newPosition);
          _targetRotations[vendor.id!] = newBearing;
          _lastKnownPositions[vendor.id!] = newPosition;

          _animateMarkerSmoothly(
            vendorId: vendor.id!,
            from: oldPosition,
            to: newPosition,
          );
        }
      }
    }

    if (mounted) setState(() {});
  }

  bool _hasPositionChanged(LatLng oldPos, LatLng newPos) {
    const double threshold = 0.00001;
    return (oldPos.latitude - newPos.latitude).abs() > threshold ||
        (oldPos.longitude - newPos.longitude).abs() > threshold;
  }

  // ============================================================
  // MARKER ANIMATION
  // ============================================================

  void _animateMarkerSmoothly({
    required String vendorId,
    required LatLng from,
    required LatLng to,
    int durationMs = 1000,
  }) {
    _markerTimers[vendorId]?.cancel();

    const int frameRate = 16;
    final int totalFrames = (durationMs / frameRate).round();
    int currentFrame = 0;

    final double startRotation = _markerRotations[vendorId] ?? 0.0;
    final double targetRotation = _targetRotations[vendorId] ?? startRotation;
    final double rotationDelta = _normalizeRotationDelta(
      startRotation,
      targetRotation,
    );

    _markerTimers[vendorId] = Timer.periodic(
      const Duration(milliseconds: frameRate),
      (timer) {
        currentFrame++;
        final double t = currentFrame / totalFrames;

        if (t >= 1.0) {
          _animatedPositions[vendorId] = to;
          _markerRotations[vendorId] = targetRotation;
          timer.cancel();
          _markerTimers.remove(vendorId);
          if (mounted) setState(() {});
          return;
        }

        final double easedT = _easeInOutCubic(t);

        final double interpolatedLat =
            from.latitude + (to.latitude - from.latitude) * easedT;
        final double interpolatedLng =
            from.longitude + (to.longitude - from.longitude) * easedT;
        _animatedPositions[vendorId] = LatLng(interpolatedLat, interpolatedLng);

        double newRotation = startRotation + rotationDelta * easedT;
        newRotation = (newRotation + 360) % 360;
        _markerRotations[vendorId] = newRotation;

        if (mounted) setState(() {});
      },
    );
  }

  double _easeInOutCubic(double t) {
    return t < 0.5
        ? 4 * t * t * t
        : 1 - (-2 * t + 2) * (-2 * t + 2) * (-2 * t + 2) / 2;
  }

  LatLng? _getAnimatedPosition(String vendorId) {
    if (_animatedPositions.containsKey(vendorId)) {
      return _animatedPositions[vendorId]!;
    }

    final liveLat = _locationService.getLat(vendorId);
    final liveLng = _locationService.getLng(vendorId);

    if (liveLat != null && liveLng != null) {
      final pos = LatLng(liveLat, liveLng);
      _animatedPositions[vendorId] = pos;
      return pos;
    }

    return null;
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

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
      setState(() => _isNearbyVendorsLoaded = true);
      _locationService.startListening();
      await getNearbyVendors();
      await _loadAssets();
    } finally {
      _isInitializingLocation = false;
    }
  }

  Future<void> getNearbyVendors() async {
    setState(() => _isNearbyVendorsLoaded = true);

    final List<VendorModel> vendorsResponse = await _userHomeService
        .getNearbyVendors(
          context: context,
          location: _userLocation,
          maxDistance: 5,
        );

    if (!mounted) return;

    setState(() => nearbyVendors = vendorsResponse);

    for (final vendor in nearbyVendors) {
      if (vendor.id != null && vendor.lat != null && vendor.lng != null) {
        final isMoving = _locationService.isLive(vendor.id!);
        final position = LatLng(vendor.lat!, vendor.lng!);

        if (isMoving) {
          _animatedPositions[vendor.id!] = position;
          _lastKnownPositions[vendor.id!] = position;
          _markerRotations[vendor.id!] = 0.0;
        } else {
          _animatedPositions[vendor.id!] = position;
        }
      }
    }
  }

  Future<void> checkLocationPermission() async {
    var status = await Geolocator.checkPermission();
    if (!mounted) return;
    setState(() => _locationPermissionStatus = status);
    permissionGranted =
        _locationPermissionStatus == LocationPermission.always ||
        _locationPermissionStatus == LocationPermission.whileInUse;

    if (!permissionGranted) {
      await _showLocationPermissionSheet();
    }
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

  // void _onSessionChanged() {
  //   if (!mounted) return;
  //   reloadUserMarker(); // ✅ Reload marker with new image
  //   setState(() {});
  // }

  // ============================================================
  // USER MARKER CREATION
  // ============================================================

  // BitmapDescriptor? _userMarker;

  // Future<void> _loadUserMarker() async {
  //   if (_userLocation == null || user == null) return;

  //   final name = user?.name?.split(' ').first ?? 'You';

  //   _userMarker = await createCustomMarker(
  //     user?.imageUrl, // profile image URL
  //     name, // label
  //   );

  //   if (mounted) setState(() {});
  // }

  /// Draws a simple person icon as fallback
  void _drawPersonIcon(Canvas canvas, double center, double borderWidth) {
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw head (circle)
    canvas.drawCircle(Offset(center, center - 10), 14, iconPaint);

    // Draw body (rounded rectangle / oval)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center, center + 18),
        width: 32,
        height: 28,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(bodyRect, iconPaint);
  }

  // Future<void> reloadUserMarker() async {
  //   await _loadUserMarker();
  //   if (mounted) setState(() {});
  // }

  // ============================================================
  // ASSET LOADING
  // ============================================================
  Future<void> _loadAssets() async {
    await Future.wait([
      _loadMapStyle(),
      _loadCustomMarker(),
      _loadMovingMarker(),
      // _loadUserMarker(), // 👈 IMPORTANT
    ]);

    if (mounted) setState(() => _assetsLoaded = true);
  }

  Future<void> _loadMapStyle() async {
    try {
      final stylePath = Assets.json.mapStyles.nightTheme;
      _mapStyle = await rootBundle.loadString(stylePath);
    } catch (_) {}
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
    } catch (_) {}
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

      final double center = circleSize / 2;

      // Draw circular background
      final backgroundPaint = Paint()
        ..color = const Color(0xFF21242B)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(center, center), center, backgroundPaint);

      // Draw green border
      final borderPaint = Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset(center, center), center - 2, borderPaint);

      // Draw the truck icon centered
      final double imageOffset = (circleSize - imageSize) / 2;
      final src = Rect.fromLTWH(
        0,
        0,
        fi.image.width.toDouble(),
        fi.image.height.toDouble(),
      );
      final dst = Rect.fromLTWH(imageOffset, imageOffset, imageSize, imageSize);
      canvas.drawImageRect(fi.image, src, dst, Paint());

      final picture = recorder.endRecording();
      final img = await picture.toImage(circleSize.toInt(), circleSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        _movingMarker = BitmapDescriptor.fromBytes(
          byteData.buffer.asUint8List(),
        );
      }
    } catch (_) {}
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
    } catch (_) {}
  }

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

  // ============================================================
  // ROUTE DRAWING
  // ============================================================

  Future<void> _drawRouteToVendor(LatLng vendor, int index) async {
    if (_isDrawingRoute) return;

    if (_isRouteSet) {
      _clearPolylinesInternal();
      return;
    }

    final user = _userLocation;
    if (user == null) {
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
      selectVendor(index);
      return;
    }

    _isDrawingRoute = true;

    try {
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(user.latitude, user.longitude),
          destination: PointLatLng(vendor.latitude, vendor.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (!mounted) return;

      if (result.points.isEmpty) {
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('straight_$index'),
              points: [user, vendor],
              width: 3,
              color: Colors.grey,
              patterns: [PatternItem.dash(10), PatternItem.gap(6)],
            ),
          );
          _isRouteSet = true;
        });
      } else {
        final coords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route_$index'),
              points: coords,
              width: 5,
              color: Colors.blue,
            ),
          );
          _isRouteSet = true;
        });
      }

      final controller = await _controller.future;

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          math.min(user.latitude, vendor.latitude),
          math.min(user.longitude, vendor.longitude),
        ),
        northeast: LatLng(
          math.max(user.latitude, vendor.latitude),
          math.max(user.longitude, vendor.longitude),
        ),
      );

      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('fallback_$index'),
            points: [user, vendor],
            width: 3,
            color: Colors.grey,
            patterns: [PatternItem.dash(10), PatternItem.gap(6)],
          ),
        );
        _isRouteSet = true;
      });

      try {
        final controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(vendor, 15));
      } catch (_) {}
    } finally {
      _isDrawingRoute = false;
    }
  }

  // ============================================================
  // STATE MANAGEMENT
  // ============================================================

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
        _polylines.isEmpty) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _selectedVendorIndex = null;
      _selectedLiveVendor = null;
      _polylines.clear();
      _isCardExpanded = false;
      _isRouteSet = false;
    });
  }

  void toggleVendorSelection(int index) {
    if (_selectedVendorIndex == index) {
      unselectVendor();
    } else {
      selectVendor(index);
    }
  }

  void _clearPolylinesInternal() {
    if (!mounted) return;
    setState(() {
      _polylines.clear();
      _isRouteSet = false;
    });
  }

  void clearPolylines() {
    if (_polylines.isEmpty && !_isRouteSet) return;
    _clearPolylinesInternal();
  }

  // ============================================================
  // MARKER BUILDING
  // ============================================================

  Set<Marker> buildMarkers({BitmapDescriptor? customMarker}) {
    final Set<Marker> markers = {};
    final Set<String> liveVendorIds = {};

    // Collect live vendor IDs
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

    // Build markers for nearby vendors
    for (var i = 0; i < nearbyVendors.length; i++) {
      final vendor = nearbyVendors[i];
      if (vendor.id == null) continue;

      double? lat;
      double? lng;
      BitmapDescriptor icon;
      double rotation = 0.0;
      bool isLive = liveVendorIds.contains(vendor.id);

      if (isLive) {
        // LIVE VENDOR
        final animatedPos = _getAnimatedPosition(vendor.id!);

        if (animatedPos != null) {
          lat = animatedPos.latitude;
          lng = animatedPos.longitude;
        } else {
          lat = _locationService.getLat(vendor.id!);
          lng = _locationService.getLng(vendor.id!);

          if (lat != null && lng != null) {
            _animatedPositions[vendor.id!] = LatLng(lat, lng);
            _lastKnownPositions[vendor.id!] = LatLng(lat, lng);
          }
        }

        rotation = _getMarkerRotation(vendor.id!);
        icon =
            _movingMarker ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else {
        // STATIC VENDOR
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
          anchor: const Offset(0.5, 0.5),
          rotation: isLive ? rotation : 0.0,
          flat: isLive,
          zIndex: isLive ? 2.0 : 1.0,
          onTap: () => toggleVendorSelection(i),
          infoWindow: InfoWindow(
            title: vendor.name,
            snippet: vendor.vendorType,
          ),
        ),
      );
    }

    // Add live vendors not in nearbyVendors list
    if (_userLocation != null) {
      final liveVendors = _locationService.getLiveVendorsNear(
        _userLocation!,
        5,
      );

      for (final lv in liveVendors) {
        final id = lv['vendorId'] as String? ?? '';
        if (id.isEmpty) continue;

        // Skip if already processed
        if (nearbyVendors.any((v) => v.id == id)) continue;

        double? lat;
        double? lng;

        final animatedPos = _getAnimatedPosition(id);
        if (animatedPos != null) {
          lat = animatedPos.latitude;
          lng = animatedPos.longitude;
        } else {
          lat = (lv['latitude'] as num?)?.toDouble();
          lng = (lv['longitude'] as num?)?.toDouble();

          if (lat != null && lng != null) {
            _animatedPositions[id] = LatLng(lat, lng);
            _lastKnownPositions[id] = LatLng(lat, lng);
          }
        }

        if (lat == null || lng == null) continue;

        final rotation = _getMarkerRotation(id);

        markers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            icon:
                _movingMarker ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
            anchor: const Offset(0.5, 0.5),
            rotation: rotation,
            flat: true,
            zIndex: 2.0,
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

    // // Add user location marker with profile image
    // if (_userLocation != null) {
    //   markers.add(
    //     Marker(
    //       markerId: const MarkerId('user'),
    //       position: _userLocation!,
    //       icon:
    //           _userMarker ??
    //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //       anchor: const Offset(0.5, 0.9), // bottom center
    //       zIndex: 10,
    //       infoWindow: const InfoWindow(title: 'You'),
    //     ),
    //   );
    // }

    return markers;
  }

  // ============================================================
  // UI BUILD METHODS
  // ============================================================

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
            onPressed: _moveCameraToUser,
            child: const Icon(Icons.my_location_sharp, color: Colors.white),
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
          const Center(child: LoadingWidget(color: Colors.white70)),
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
                onTap: () => UserHomeService.gotoNotifications(context),
                child: const NotificationsBtn(),
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
      polylines: _polylines,
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
      onTap: (_) => unselectVendor(),
    );
  }

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () {
        if (!_isUserLocationSet) return;
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
            nearbyVendors.add(searchedVendor);

            if (searchedVendor.lat != null && searchedVendor.lng != null) {
              _animatedPositions[searchedVendor.id!] = LatLng(
                searchedVendor.lat!,
                searchedVendor.lng!,
              );
              _lastKnownPositions[searchedVendor.id!] = LatLng(
                searchedVendor.lat!,
                searchedVendor.lng!,
              );
            }
          }

          final index = nearbyVendors.indexWhere(
            (v) => v.id == searchedVendor.id,
          );
          if (index != -1) {
            selectVendor(index);

            double? lat;
            double? lng;

            final animatedPos = _getAnimatedPosition(searchedVendor.id!);
            if (animatedPos != null) {
              lat = animatedPos.latitude;
              lng = animatedPos.longitude;
            } else if (_locationService.isLive(searchedVendor.id!)) {
              lat = _locationService.getLat(searchedVendor.id!);
              lng = _locationService.getLng(searchedVendor.id!);
            } else {
              lat = searchedVendor.lat;
              lng = searchedVendor.lng;
            }

            if (_userLocation != null && lat != null && lng != null) {
              await _drawRouteToVendor(LatLng(lat, lng), index);
            }
          }
        },
        'userLocation': userLocation,
      },
    );
  }

  Widget _buildUserVendorCard() {
    if (_selectedLiveVendor != null) {
      final lv = _selectedLiveVendor!;

      final animatedPos = _getAnimatedPosition(lv['vendorId'] ?? '');
      final lat = animatedPos?.latitude ?? (lv['latitude'] as num?)?.toDouble();
      final lng =
          animatedPos?.longitude ?? (lv['longitude'] as num?)?.toDouble();

      double distance = 0.0;
      if (_userLocation != null && lat != null && lng != null) {
        distance = _calculateDistance(
          _userLocation!.latitude,
          _userLocation!.longitude,
          lat,
          lng,
        );
      }

      return VendorCard(
        vendorId: lv['vendorId'] ?? '',
        isExpanded: _isCardExpanded,
        isRouteSet: _isRouteSet,
        onTap: () async {
          if (!mounted) return;
          setState(() => _isCardExpanded = !_isCardExpanded);
        },
        distance: _roundToOneDecimal(distance),
        vendorName: lv['name'] ?? '',
        imageUrl: lv['profileImage'] ?? '',
        vendorAddress: '',
        vendorType: lv['vendorType'] ?? '',
        menuLength: lv['menuCount'] ?? 0,
        hoursADay: (lv['hoursADay'] ?? 0).toString(),
        onGetDirection: () async {
          if (lat != null && lng != null) {
            await _drawRouteToVendor(LatLng(lat, lng), 0);
            if (!mounted) return;
            setState(() => _isCardExpanded = false);
          } else {
            context.flushBarErrorMessage(
              message: 'Vendor location not available',
            );
          }
        },
      );
    }

    final selected = selectedVendor;
    if (selected == null) return const SizedBox.shrink();

    double? lat;
    double? lng;

    final animatedPos = _getAnimatedPosition(selected.id!);
    if (animatedPos != null) {
      lat = animatedPos.latitude;
      lng = animatedPos.longitude;
    } else if (_locationService.isLive(selected.id!)) {
      lat = _locationService.getLat(selected.id!);
      lng = _locationService.getLng(selected.id!);
    } else {
      lat = selected.lat;
      lng = selected.lng;
    }

    double distance = selected.distanceInKm ?? 0.0;
    if (_locationService.isLive(selected.id!) &&
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
      vendorId: selected.id!,
      isExpanded: _isCardExpanded,
      isRouteSet: _isRouteSet,
      onTap: () async {
        if (!mounted) return;
        setState(() => _isCardExpanded = !_isCardExpanded);
      },
      distance: _roundToOneDecimal(distance),
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

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371.0;
    final double dLat = (lat2 - lat1) * math.pi / 180.0;
    final double dLng = (lng2 - lng1) * math.pi / 180.0;

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
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
