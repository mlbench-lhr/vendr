import 'dart:developer';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/routes/unknown_page.dart';
import 'package:flutter/material.dart';
import 'package:vendr/view/auth/forgot_password/forgot_password.dart';
import 'package:vendr/view/auth/forgot_password/new_password.dart';
import 'package:vendr/view/auth/login.dart';
import 'package:vendr/view/auth/profile_type.dart';
import 'package:vendr/view/auth/user/user_signup.dart';
import 'package:vendr/view/auth/vendor/vendor_signup.dart';
import 'package:vendr/view/auth/welcome.dart';
import 'package:vendr/view/home/user/user_home.dart';
import 'package:vendr/view/home/vendor/vendor_home.dart';
import 'package:vendr/view/profile/languages.dart';
import 'package:vendr/view/profile/vendor/add_edit_product.dart';
import 'package:vendr/view/profile/vendor/change_email.dart';
import 'package:vendr/view/profile/vendor/change_phone.dart';
import 'package:vendr/view/profile/vendor/edit_profile.dart';
import 'package:vendr/view/profile/vendor/location.dart';
import 'package:vendr/view/profile/vendor/my_menu.dart';
import 'package:vendr/view/profile/vendor/vendor_hours.dart';
import 'package:vendr/view/profile/vendor/vendor_profile.dart';
import 'package:vendr/view/reviews/reviews.dart';

class Routes {
  static String initialRoute() => RoutesName.welcome;
  // static String initialRoute() => RoutesName.vendorChangeEmail;

  static final Map<String, WidgetBuilder> _routes = {
    RoutesName.welcome: (_) => const WelcomeScreen(),
    RoutesName.profileTypeSelection: (_) => const ProfileTypeSelectionScreen(),
    RoutesName.userSignup: (_) => const UserSignupScreen(),
    RoutesName.vendorSignup: (_) => const VendorSignupScreen(),
    RoutesName.forgotPassword: (_) => const ForgotPasswordScreen(),
    RoutesName.newPassword: (_) => const NewPasswordScreen(),
    RoutesName.vendorHome: (_) => const VendorHomeScreen(),
    RoutesName.userHome: (_) => const UserHomeScreen(),
    RoutesName.vendorProfile: (_) => const VendorProfileScreen(),
    RoutesName.vendorMyMenu: (_) => const VendorMyMenuScreen(),
    RoutesName.vendorEditProfile: (_) => const VendorEditProfileScreen(),
    RoutesName.vendorHours: (_) => const VendorHoursScreen(),
    RoutesName.vendorLocation: (_) => const VendorLocationScreen(),
    RoutesName.languages: (_) => const LanguagesScreen(),
    RoutesName.vendorChangePhoneNumber: (_) => const ChangePhoneNumberScreen(),
    RoutesName.vendorChangeEmail: (_) => const ChangeEmailScreen(),
    RoutesName.reviews: (_) => const ReviewsScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    log(
      'Navigating to: ${settings.name}\t - ${settings.arguments}',
      name: 'RouteGenerator',
    );
    switch (settings.name) {
      // case RoutesName.doctorOnboarding:
      //   final args = _getArgs(settings, requiredKeys: ['showBack']);
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         DoctorOnboardingFlowScreen(showBack: args['showBack'] as bool),
      //   );

      //login
      case RoutesName.login:
        final args = _getArgs(settings, requiredKeys: ['isVendor']);
        return MaterialPageRoute(
          builder: (_) => LoginScreen(isVendor: args['isVendor'] as bool),
        );

      //add or edit product
      case RoutesName.vendorAddEditProduct:
        final args = _getArgs(settings, requiredKeys: ['isEdit']);
        return MaterialPageRoute(
          builder: (_) => AddEditProductScreen(isEdit: args['isEdit'] as bool),
        );

      default:
        final builder = _routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }
        return MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
    }
  }

  static Map<String, dynamic> _getArgs(
    RouteSettings settings, {
    required List<String> requiredKeys,
  }) {
    try {
      final args = settings.arguments! as Map<String, dynamic>;
      for (final key in requiredKeys) {
        if (!args.containsKey(key)) {
          throw ArgumentError('Missing required key: $key');
        }
      }
      return args;
    } catch (e) {
      throw ArgumentError('Invalid arguments for route ${settings.name}');
    }
  }
}
