import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vendor {
  final String name;
  final String imageUrl;
  final String address;
  final LatLng location;
  final String type;
  final String menu;
  final String hours;

  Vendor({
    required this.name,
    required this.address,
    required this.location,
    required this.type,
    required this.menu,
    required this.hours,
    required this.imageUrl,
  });
}
