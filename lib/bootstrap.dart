import 'dart:async';
import 'dart:developer';
// import 'package:vendr/firebase_options.dart';
import 'package:vendr/provider/providers.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  // Always show top + bottom overlays (status bar + nav bar)
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Add cross-flavor configuration here
  await SessionController().init();

  runApp(MultiProvider(providers: providers, child: await builder()));
}
