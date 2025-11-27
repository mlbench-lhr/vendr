import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class UserProfileService {
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
}
