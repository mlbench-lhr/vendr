// lib/services/common/vendor_location_service.dart

import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendr/services/vendor/vendor_home_service.dart';

import 'session_manager/session_controller.dart';

class VendorLocationService {
  static final VendorLocationService _instance =
      VendorLocationService._internal();
  factory VendorLocationService() => _instance;

  VendorLocationService._internal() {
    _ref = FirebaseDatabase.instance.ref('live_vendor_locations');
  }

  late final DatabaseReference _ref;
  final _session = SessionController();

  // ================== CONSTANTS ==================
  static const int _staleSeconds = 45;

  // ================== VENDOR SIDE ==================
  StreamSubscription<Position>? _posSub;
  Timer? _heartbeat;
  bool _isSharing = false;
  String? _vendorId;

  bool get isSharing => _isSharing;

  /// Start sharing vendor location
  Future<void> startSharing() async {
    if (_isSharing) return;

    final v = _session.vendor;
    if (v?.id == null) throw Exception('Vendor not logged in');

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services disabled');
    }

    _vendorId = v!.id;
    _isSharing = true;

    await _setupOnDisconnect();

    // Send initial location
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      await _sendLocation(pos);
    } catch (_) {}

    // Listen for position updates
    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(_sendLocation);

    // Heartbeat to keep status online
    _heartbeat = Timer.periodic(const Duration(seconds: 15), (_) async {
      if (_vendorId != null && _isSharing) {
        await _ref.child(_vendorId!).update({
          'status': 'online',
          'lastUpdated': ServerValue.timestamp,
        });
      }
    });
  }

  /// Setup onDisconnect for Firebase
  Future<void> _setupOnDisconnect() async {
    if (_vendorId == null) return;
    try {
      await _ref
          .child(_vendorId!)
          .child('status')
          .onDisconnect()
          .set('offline');
      await _ref
          .child(_vendorId!)
          .child('lastUpdated')
          .onDisconnect()
          .set(ServerValue.timestamp);
    } catch (_) {}
  }

  /// Send current location to Firebase
  Future<void> _sendLocation(Position pos) async {
    final v = _session.vendor;
    if (v == null || _vendorId == null || !_isSharing) return;

    await _ref.child(_vendorId!).set({
      'vendorId': v.id,
      'name': v.name,
      'vendorType': v.vendorType,
      'profileImage': v.profileImage ?? '',
      'menuCount': v.menu?.length ?? 0,
      'hoursADay': VendorHomeService.getVendorWorkingHoursToday(
        vendorHours: v.hours,
      ),
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'status': 'online',
      'lastUpdated': ServerValue.timestamp,
    });

    await _setupOnDisconnect();
  }

  /// Stop sharing vendor location
  Future<void> stopSharing() async {
    _heartbeat?.cancel();
    _heartbeat = null;
    await _posSub?.cancel();
    _posSub = null;

    final vendorId = _vendorId;
    _isSharing = false;
    _vendorId = null;

    if (vendorId != null) {
      await _ref.child(vendorId).onDisconnect().cancel();
      await _ref.child(vendorId).update({
        'status': 'offline',
        'lastUpdated': ServerValue.timestamp,
      });
    }
  }

  // ================== CUSTOMER SIDE ==================
  StreamSubscription<DatabaseEvent>? _listenerSub;
  final _liveVendors = <String, Map<String, dynamic>>{};
  final _onUpdate = StreamController<void>.broadcast();
  Stream<void> get onUpdate => _onUpdate.stream;
  bool _isListening = false;
  int _serverOffset = 0;

  /// Listen for live vendors from Firebase
  void startListening() {
    if (_isListening) return;
    _isListening = true;

    FirebaseDatabase.instance.ref('.info/serverTimeOffset').onValue.listen((e) {
      _serverOffset = (e.snapshot.value as num?)?.toInt() ?? 0;
    });

    _listenerSub = _ref.onValue.listen((event) {
      _liveVendors.clear();
      if (event.snapshot.value is! Map) {
        _onUpdate.add(null);
        return;
      }

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final serverNow = DateTime.now().millisecondsSinceEpoch + _serverOffset;

      for (final e in data.entries) {
        if (e.value is! Map) continue;

        final m = Map<String, dynamic>.from(e.value as Map);
        final ts = (m['lastUpdated'] as num?)?.toInt() ?? 0;
        final status = m['status'] ?? 'offline';
        final ageSeconds = (serverNow - ts) / 1000;

        // Only include vendors who are online and recently updated
        if (status == 'online' && ageSeconds <= _staleSeconds) {
          _liveVendors[e.key] = m;
        }
      }

      _onUpdate.add(null);
    });
  }

  void stopListening() {
    _listenerSub?.cancel();
    _listenerSub = null;
    _liveVendors.clear();
    _isListening = false;
  }

  // ================== GETTERS ==================
  List<Map<String, dynamic>> getLiveVendorsNear(LatLng user, double maxKm) {
    return _liveVendors.entries
        .where((e) {
          final lat = (e.value['latitude'] as num?)?.toDouble();
          final lng = (e.value['longitude'] as num?)?.toDouble();
          if (lat == null || lng == null) return false;
          return _dist(user.latitude, user.longitude, lat, lng) <= maxKm;
        })
        .map((e) => {...e.value, 'vendorId': e.key})
        .toList();
  }

  bool isLive(String id) => _liveVendors.containsKey(id);
  double? getLat(String id) =>
      (_liveVendors[id]?['latitude'] as num?)?.toDouble();
  double? getLng(String id) =>
      (_liveVendors[id]?['longitude'] as num?)?.toDouble();

  double _dist(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  void dispose() {
    stopSharing();
    stopListening();
    if (!_onUpdate.isClosed) _onUpdate.close();
  }
}
