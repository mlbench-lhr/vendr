import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/provider/auth/locale_provider.dart';
import 'package:vendr/provider/user_home_provider.dart';

final List<Vendor> initialVendors = [
  Vendor(
    name: 'Harry Brook',
    address: '15 Maiden Ln Suite 908, New York, NY 10038',
    location: LatLng(31.50293, 74.34801),
    type: 'Food vendor',
    menu: '25 products',
    hours: '8 Hours',
    imageUrl:
        'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=80',
  ),
  Vendor(
    name: 'Emma Stone',
    address: '22 Broadway, New York, NY 10007',
    location: LatLng(31.46719, 74.26598),
    type: 'Grocery vendor',
    menu: '50 products',
    hours: '10 Hours',
    imageUrl:
        'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  Vendor(
    name: 'Tom Hanks',
    address: '34 Wall Street, New York, NY 10005',
    location: LatLng(31.47124, 74.35593),
    type: 'Electronics vendor',
    menu: '15 products',
    hours: '9 Hours',
    imageUrl:
        'https://images.unsplash.com/photo-1519520104014-df63821cb6f9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  Vendor(
    name: 'Sophia Lee',
    address: '10 Park Ave, New York, NY 10016',
    location: LatLng(31.450, 74.310),
    type: 'Clothing vendor',
    menu: '35 products',
    hours: '12 Hours',
    imageUrl:
        'https://images.unsplash.com/photo-1762844877991-54c007866283?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
];

final providers = <SingleChildWidget>[
  // ChangeNotifierProvider(create: (_) => NavigationProvider()),
  // ChangeNotifierProvider(create: (_) => DoctorProvider(), lazy: false),
  ChangeNotifierProvider(create: (_) => LocaleNotifier()),
  ChangeNotifierProvider(
    create: (_) => UserHomeProvider(vendors: initialVendors),
  ),
  // ChangeNotifierProvider(create: (_) => FilterProvider()),
  // Add more providers here
];
