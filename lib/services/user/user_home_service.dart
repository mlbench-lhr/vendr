import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class UserHomeService {
  static void gotoNotifications(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.notificationScreen);
  }

  static void gotoSearch(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userSearch);
  }
}
