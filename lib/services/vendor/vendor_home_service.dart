import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class VendorHomeService {
  static void gotoVendorProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorProfile);
  }
}
