import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorProfileService {
  static void gotoVendorMyMenu(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorMyMenu);
  }

  static void gotoVendorAddProduct(BuildContext context, bool isEdit) {
    Navigator.pushNamed(
      context,
      arguments: {'isEdit': isEdit},
      RoutesName.vendorAddEditProduct,
    );
  }
}
