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
  vendor('vendor');

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

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  UserModel? get user => _user;
  VendorModel? get vendor => _vendor;
  bool get isLoggedIn => _token != null;

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
    log('Vendor saved: ${vendor.id}');
  }

  Future<void> saveUser(UserModel user) async {
    _user = user;
    notifyListeners();
    final encoded = jsonEncode(user.toJson());
    await _localStorage.setValue(StorageKey.user.value, encoded);
    log('User saved: ${user.id}');
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
    // notifyListeners(); //causes error
    log('Session cleared: All data removed');
  }
}
