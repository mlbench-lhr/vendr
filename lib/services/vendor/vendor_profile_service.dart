import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorProfileService {
  static void gotoVendorMyMenu(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorMyMenu);
  }

  static void gotoVendorEditProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorEditProfile);
  }

  static void gotoVendorHours(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorHours);
  }

  static void gotoVendorLocation(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorLocation);
  }

  static void gotoLanguagesScreen(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.languages);
  }

  static void gotoChangePhoneNumber(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorChangePhoneNumber);
  }

  static void gotoChangeEmail(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorChangeEmail);
  }

  static void gotoVendorAddProduct(BuildContext context, bool isEdit) {
    Navigator.pushNamed(
      context,
      arguments: {'isEdit': isEdit},
      RoutesName.vendorAddEditProduct,
    );
  }
}
