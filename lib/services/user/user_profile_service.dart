import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/repository/user_auth_repo.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class UserProfileService {
  String tag = '[User Profile Service]';
  final _sessionController = SessionController();
  final _userAuthRepo = UserAuthRepository();
  static void gotoUserProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userProfile);
  }

  static void gotoUserEditProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userEditProfile);
  }

  static void gotoUserFavorites(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userFavorites);
  }

  static void gotoNotificationPreferences(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.notificationPerefrences);
  }

  ///Update User Profile
  Future<void> updateUserProfile(
    BuildContext context, {
    String? name,
    String? imageUrl,
    bool? newVendorAlert,
    bool? distanceBasedAlert,
    bool? favoriteVendorAlert,
    VoidCallback? onSuccess,
  }) async {
    final user = _sessionController.user;
    final Map<String, dynamic> data = {
      if (name != null && user!.name != name) 'name': name,
      if (newVendorAlert != null && user!.newVendorAlert != newVendorAlert)
        'new_vendor_alert': newVendorAlert,
      if (distanceBasedAlert != null &&
          user!.distanceBasedAlert != distanceBasedAlert)
        'distance_based_alert': distanceBasedAlert,
      if (favoriteVendorAlert != null &&
          user!.favoriteVendorAlert != favoriteVendorAlert)
        'favorite_vendor_alert': favoriteVendorAlert,
      if (imageUrl != null && user!.imageUrl != imageUrl)
        'profile_image': imageUrl,
    };
    try {
      await _userAuthRepo.updateuserProfile(data);
      if (context.mounted) {
        onSuccess?.call();
        AuthService().fetchProfile(context);
      }
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///addToFavorites
  ///
  Future<void> removeFromFavorites(
    BuildContext context, {
    required String vendorId,
    VoidCallback? onRemoved,
  }) async {
    try {
      await _userAuthRepo.removeFromFavorites(vendorId: vendorId);
      onRemoved?.call();
      if (context.mounted) {
        await AuthService().fetchProfile(context);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
    }
  }
}
