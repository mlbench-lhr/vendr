import 'package:vendr/app/routes/routes.dart';
import 'package:vendr/app/styles/app_dimensions.dart';
import 'package:vendr/app/styles/theme_factory.dart';
import 'package:vendr/l10n/arb/app_localizations.dart';
import 'package:vendr/provider/auth/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vendr/view/auth/welcome.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDimensions.mockSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final locale = context.watch<LocaleNotifier>().locale;
        return MaterialApp(
          title: 'Vendr',
          debugShowCheckedModeBanner: false, //hide debug banner
          themeMode: ThemeMode.light,
          theme: ThemeFactory.darkThemeData(),
          darkTheme: ThemeFactory.darkThemeData(),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: Routes.initialRoute(),
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}
