import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vendr/app/utils/enums.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/repository/user/user_notifications_repo.dart';
import 'package:vendr/repository/vendor/vendor_notifications_repo.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class PushNotificationsService {
  final String tag = 'NotificationsService';
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final SessionController _session = SessionController();
  final UserNotificationsRepository _userRepo = UserNotificationsRepository();
  final VendorNotificationsRepository _doctorRepo =
      VendorNotificationsRepository();

  /// Initialize Firebase Messaging
  // 1. Add this static variable at the top of your class (outside the function)
  static bool _isInitializing = false;

  /// Initialize Firebase Messaging
  Future<void> initialize(
    BuildContext context, {
    required String userId,
    double? userLat,
    double? userLng,
  }) async {
    // 2. Lock check: If already running, exit to prevent the "already running" Exception
    if (_isInitializing) {
      debugPrint(
        'ℹ️ FCM initialization already in progress. Skipping duplicate call.',
      );
      return;
    }

    _isInitializing = true; // Set the lock

    try {
      ///
      ///Check if device is Simulator (Push notifications only work on Physical Device)
      ///(Push notifications only work on Physical Device)
      ///
      if (await isIOSSimulator()) {
        debugPrint('⚠️ iOS Simulator detected — skipping FCM init');
        return;
      }

      debugPrint('🔔 Initializing Notifications for user: $userId');

      // 1. Capture the permission settings
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(alert: true, sound: true, badge: true);

      // 2. Check if permission was granted
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('🚫 User denied notification permissions.');
        return; // EXIT HERE before getting token
      }

      // Optional: Handle "Provisional" (iOS quiet notifications) if you want to allow them
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        debugPrint('⚪ Notification permission not determined.');
        return;
      }

      debugPrint('✅ Notification permission granted.');

      final String? token = await _firebaseMessaging.getToken();
      debugPrint('TOKEN RECEIVED $token');
      debugPrint('📌 FCM Token: $token');

      if (token != null) {
        // Send token to your server
        // ignore: use_build_context_synchronously
        await sendTokenToServer(
          context,
          userId: userId,
          token: token,
          userLat: userLat,
          userLng: userLng,
        );
      }

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //Perform any action you want
        debugPrint(
          '📩 Foreground Notification: ${message.notification?.title} - ${message.notification?.body}',
        );
      });

      // App opened from terminated state
      await FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          //Perform any action you want
          debugPrint(
            '📩 Notification caused app launch: ${message.notification?.body}',
          );
        }
      });

      // App in background and user taps notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('📩 Notification clicked: ${message.notification?.body}');
      });
    } catch (e) {
      debugPrint('❌ FCM Initialization Error: $e');
    } finally {
      // 3. IMPORTANT: Unlock the function so it can be called again if needed later
      _isInitializing = false;
    }
  }

  Future<void> initAPNSToken() async {
    final String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint('📌 APNs Token: $apnsToken');
  }

  //Save token against user id in server
  Future<void> sendTokenToServer(
    BuildContext context, {
    required String userId,
    required String token,
    double? userLat,
    double? userLng,
  }) async {
    try {
      if (_session.userType == UserType.user) {
        await _userRepo.sendToken(
          userId: userId,
          token: token,
          userLat: userLat,
          userLng: userLng,
        );
      } else {
        await _doctorRepo.sendToken(vendorId: userId, token: token);
      }
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  //send notification to specific user
  Future<void> pushNotification(
    BuildContext context,
    String receiverId,
    String title,
    String message,
  ) async {
    debugPrint('🎒USER TYPE HERE IS: ${_session.userType}');
    try {
      if (_session.userType == UserType.user) {
        await _userRepo.sendNotification(
          doctorId: receiverId,
          title: title,
          message: message,
        );
      } else {
        await _doctorRepo.sendNotification(
          userId: receiverId,
          title: title,
          message: message,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(
          context,
          e,
          serviceName: tag,
        ); //TODO: This will show the error
      }
    }
  }

  ///
  ///Initialize
  ///
  Future<void> initFCM({
    required BuildContext context,
    double? userLat,
    double? userLng,
  }) async {
    debugPrint('IN INIT FCM');
    String id = '';
    if (_session.userType == UserType.user) {
      debugPrint('User is a regular user');
      id = _session.user?.id ?? '';
    } else {
      debugPrint('User is a doctor');
      id = _session.vendor?.id ?? '';
    }
    debugPrint('Initializing FCM for user ID: $id');
    initialize(context, userId: id, userLat: userLat, userLng: userLng);
  }

  Future<bool> isIOSSimulator() async {
    if (!Platform.isIOS) return false;

    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    return !iosInfo.isPhysicalDevice;
  }
}
