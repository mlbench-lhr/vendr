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
  Future<void> initialize(BuildContext context, String userId) async {
    ///
    ///Check if device is Simulator (Push notifications only work on Physical Device)
    ///(Push notifications only work on Physical Device)
    ///
    if (await isIOSSimulator()) {
      debugPrint('⚠️ iOS Simulator detected — skipping FCM init');
      return;
    }

    debugPrint('🔔 Initializing Notifications for user: $userId');
    // Ask for notification permissions (important for iOS)
    await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    final String? token = await _firebaseMessaging.getToken();
    debugPrint('TOKEN RECEIVED $token');
    debugPrint('📌 FCM Token: $token');

    if (token != null) {
      // Send token to your server
      // ignore: use_build_context_synchronously
      await sendTokenToServer(context, userId, token);
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
  }

  Future<void> initAPNSToken() async {
    final String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint('📌 APNs Token: $apnsToken');
  }

  //Save token against user id in server
  Future<void> sendTokenToServer(
    BuildContext context,
    String userId,
    String token,
  ) async {
    try {
      if (_session.userType == UserType.user) {
        await _userRepo.sendToken(userId: userId, token: token);
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
  Future<void> initFCM({required BuildContext context}) async {
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
    initialize(context, id);
  }

  Future<bool> isIOSSimulator() async {
    if (!Platform.isIOS) return false;

    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    return !iosInfo.isPhysicalDevice;
  }
}
