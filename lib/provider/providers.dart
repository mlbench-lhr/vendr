import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vendr/provider/auth/locale_provider.dart';

final providers = <SingleChildWidget>[
  // ChangeNotifierProvider(create: (_) => NavigationProvider()),
  // ChangeNotifierProvider(create: (_) => DoctorProvider(), lazy: false),
  ChangeNotifierProvider(create: (_) => LocaleNotifier()),
  // ChangeNotifierProvider(create: (_) => FilterProvider()),
  // Add more providers here
];
