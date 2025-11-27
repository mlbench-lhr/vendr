import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorHomeService {
  static void gotoVendorProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorProfile);
  }

  static void gotoReviews(BuildContext context, {bool isVendor = true}) {
    Navigator.pushNamed(
      context,
      arguments: {'isVendor': isVendor},
      RoutesName.reviews,
    );
  }
}
