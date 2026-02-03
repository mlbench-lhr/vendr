// Enum for storage keys to prevent typos
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vendr/app/utils/enums.dart';
import 'package:vendr/app/utils/local_storage.dart';
import 'package:vendr/model/user/user_model.dart';
import 'dart:developer';
import 'package:vendr/model/vendor/vendor_model.dart';

enum StorageKey {
  accessToken('access_token'),
  refreshToken('refresh_token'),
  userType('user_type'),
  user('user'),
  vendor('vendor'),
  distanceFilter('distance_filter');

  const StorageKey(this.value);
  final String value;
}

class SessionController extends ChangeNotifier {
  factory SessionController() => _instance;
  SessionController._internal();
  static final SessionController _instance = SessionController._internal();
  final LocalStorage _localStorage = LocalStorage();

  String? _token;
  String? _refreshToken;
  VendorModel? _vendor;
  UserModel? _user;
  UserType? userType;
  double _distanceFilter = 5.0; // Default 5km

  String? get token => _token;
  String? get refreshToken =>
      _refreshToken; //TODO: Refresh token logic isn't implemented yet.
  UserModel? get user => _user;
  VendorModel? get vendor => _vendor;
  bool get isLoggedIn => _token != null;
  double get distanceFilter => _distanceFilter;

  bool _initialized = false;
  Future<void>? _initFuture;

  Future<void> init() {
    if (_initialized) return Future.value();
    _initFuture ??= _initializeSession();
    return _initFuture!;
  }

  Future<void> _initializeSession() async {
    _token = await _localStorage.readValue(StorageKey.accessToken.value);
    _refreshToken = await _localStorage.readValue(
      StorageKey.refreshToken.value,
    );
    final type = await _localStorage.readValue(StorageKey.userType.value);

    // Load vendor data
    final vendorString = await _localStorage.readValue(StorageKey.vendor.value);
    if (vendorString != null) {
      try {
        final vendorJson = jsonDecode(vendorString) as Map<String, dynamic>;
        _vendor = VendorModel.fromJson(vendorJson);
        log('Vendor loaded from storage - hasPermit: ${_vendor?.hasPermit}');
      } catch (e) {
        log('Failed to decode user: $e');
        _vendor = null;
      }
    }
    // // Load user data
    // final userString = await _localStorage.readValue(StorageKey.user.value);
    // if (userString != null) {
    //   try {
    //     final userJson = jsonDecode(userString) as Map<String, dynamic>;
    //     _user = UserModel.fromJson(userJson);
    //   } catch (e) {
    //     log('Failed to decode user: $e');
    //     _user = null;
    //   }
    // }

    if (type != null) {
      userType = UserType.fromString(type);
      log('User type loaded: $type');
    }
    if (_token != null) {
      log('Token loaded: $_token');
    }

    // Load distance filter preference
    final distanceStr = await _localStorage.readValue(
      StorageKey.distanceFilter.value,
    );
    if (distanceStr != null) {
      _distanceFilter = double.tryParse(distanceStr) ?? 5.0;
      log('Distance filter loaded: $_distanceFilter km');
    }

    _initialized = true;
  }

  Future<void> saveUserType() async {
    if (userType == null) {
      log('User type is null, cannot save to local storage');
      return;
    }
    await _localStorage.setValue(StorageKey.userType.value, userType!.value);
    log('User type saved: ${userType!.value}');
  }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    _token = accessToken;
    _refreshToken = refreshToken;
    await _localStorage.setValue(StorageKey.accessToken.value, accessToken);
    log('Access Token saved: $token');
    await _localStorage.setValue(StorageKey.refreshToken.value, refreshToken);
    log('Refresh Token saved: $refreshToken');
  }

  Future<void> saveVendor(VendorModel vendor) async {
    _vendor = vendor;
    final encoded = jsonEncode(vendor.toJson());
    await _localStorage.setValue(StorageKey.vendor.value, encoded);
    notifyListeners();
    log('Vendor saved: ${vendor.id} - hasPermit: ${vendor.hasPermit}');
  }

  Future<void> saveUser(UserModel user) async {
    _user = user;
    notifyListeners();
    final encoded = jsonEncode(user.toJson());
    await _localStorage.setValue(StorageKey.user.value, encoded);
    log('User saved: ${user.id}');
  }

  Future<void> saveDistanceFilter(double distance) async {
    _distanceFilter = distance;
    await _localStorage.setValue(
      StorageKey.distanceFilter.value,
      distance.toString(),
    );
    log('Distance filter saved: $distance km');
  }

  /// Decrements the user's remaining meetup requests by 1
  /// Each user gets 10 requests per day (default from API)
  /// This only updates locally - the server resets to 10 daily
  Future<bool> decrementRequestsRemaining() async {
    if (_user == null) {
      log('Cannot decrement requests: user is null');
      return false;
    }

    final currentRequests = _user!.requestsRemaining ?? 0;
    if (currentRequests <= 0) {
      log('Cannot decrement requests: already at 0');
      return false;
    }

    // Create a new UserModel with decremented requests
    final updatedUser = UserModel(
      id: _user!.id,
      email: _user!.email,
      name: _user!.name,
      imageUrl: _user!.imageUrl,
      createdAt: _user!.createdAt,
      updatedAt: _user!.updatedAt,
      favoriteVendors: _user!.favoriteVendors,
      newVendorAlert: _user!.newVendorAlert,
      distanceBasedAlert: _user!.distanceBasedAlert,
      favoriteVendorAlert: _user!.favoriteVendorAlert,
      lat: _user!.lat,
      lng: _user!.lng,
      requestsRemaining: currentRequests - 1,
      requestsLastResetAt: _user!.requestsLastResetAt,
      language: _user!.language,
      averageRating: _user!.averageRating,
      totalReviews: _user!.totalReviews,
    );

    await saveUser(updatedUser);
    log('Requests remaining decremented to: ${currentRequests - 1}');
    return true;
  }

  //   Future<void> saveUser(UserModel user) async {
  //     _user = user;
  //     final encoded = jsonEncode(user.toJson());
  //     await _localStorage.setValue(StorageKey.user.value, encoded);
  //     log('User saved: ${user.id}');
  //   }

  Future<void> clearSession() async {
    _token = null;
    _refreshToken = null;
    _vendor = null;
    userType = null;
    _user = null;
    // Clear all storage values using the enum
    await _localStorage.clearValue(StorageKey.accessToken.value);
    await _localStorage.clearValue(StorageKey.refreshToken.value);
    await _localStorage.clearValue(StorageKey.userType.value);
    await _localStorage.clearValue(StorageKey.vendor.value);
    await _localStorage.clearValue(StorageKey.user.value);

    log('Session cleared: All data removed');
  }
}
