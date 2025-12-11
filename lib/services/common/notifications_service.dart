import 'package:flutter/material.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/general/notification_model.dart';
import 'package:vendr/repository/user_auth_repo.dart';

class NotificationsService {
  static const String tag = '[AuthService]';
  final UserAuthRepository _userAuthRepo = UserAuthRepository();

  ///
  ///Get Notifications
  ///
  Future<List<NotificationModel>> getNotifications({
    required BuildContext context,
  }) async {
    try {
      final response = await _userAuthRepo.getNotifications();

      debugPrint("🔔 Notifications Response $response");

      final notifications = (response['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return notifications;
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return [];
    }
  }
}
