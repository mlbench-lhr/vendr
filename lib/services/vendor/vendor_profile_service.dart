import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorProfileService {
  static void gotoVendorMyMenu(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorMyMenu);
  }
}
