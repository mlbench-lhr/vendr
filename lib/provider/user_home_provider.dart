// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:vendr/model/vendor/vendor_model.dart';

// class UserHomeProvider extends ChangeNotifier {
//   final List<VendorModel> vendors;

//   LatLng? _userLocation;
//   int? _selectedVendorIndex;
//   final Set<Polyline> _polylines = {};

//   UserHomeProvider({required this.vendors});

//   LatLng? get userLocation => _userLocation;
//   int? get selectedVendorIndex => _selectedVendorIndex;
//   VendorModel? get selectedVendor =>
//       (_selectedVendorIndex != null) ? vendors[_selectedVendorIndex!] : null;

//   Set<Polyline> get polylines => Set.unmodifiable(_polylines);

//   void updateUserLocation(LatLng newLocation) {
//     if (_userLocation == newLocation) return;
//     _userLocation = newLocation;
//     notifyListeners();
//   }

//   void selectVendor(int index) {
//     if (index < 0 || index >= vendors.length) return;
//     if (_selectedVendorIndex == index) return;
//     _selectedVendorIndex = index;
//     notifyListeners();
//   }

//   void unselectVendor() {
//     if (_selectedVendorIndex == null && _polylines.isEmpty) return;
//     _selectedVendorIndex = null;
//     _polylines.clear();
//     notifyListeners();
//   }

//   void toggleVendorSelection(int index) {
//     if (_selectedVendorIndex == index) {
//       unselectVendor();
//     } else {
//       selectVendor(index);
//     }
//   }

//   void addOrReplacePolyline(Polyline polyline) {
//     _polylines.removeWhere((p) => p.polylineId == polyline.polylineId);
//     _polylines.add(polyline);
//     notifyListeners();
//   }

//   void clearPolylines() {
//     if (_polylines.isEmpty) return;
//     _polylines.clear();
//     notifyListeners();
//   }

//   Set<Marker> buildMarkers({BitmapDescriptor? customMarker}) {
//     final Set<Marker> markers = {};

//     for (var i = 0; i < vendors.length; i++) {
//       final vendor = vendors[i];
//       if (vendor.location != null) {
//         markers.add(
//           Marker(
//             markerId: MarkerId('vendor_$i'),
//             position: vendor.location!,
//             icon: customMarker ?? BitmapDescriptor.defaultMarker,
//             onTap: () => toggleVendorSelection(i),
//             infoWindow: InfoWindow(title: vendor.name),
//           ),
//         );
//       }
//     }

//     if (_userLocation != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('user'),
//           position: _userLocation!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueAzure,
//           ),
//           infoWindow: const InfoWindow(title: 'Your Location'),
//         ),
//       );
//     }

//     return markers;
//   }
// }
