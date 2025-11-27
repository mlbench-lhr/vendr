// import 'dart:async';
// import 'package:esthetic_match/app/components/my_bottom_sheet.dart';
// import 'package:esthetic_match/app/routes/routes_name.dart';
// import 'package:esthetic_match/app/utils/enums.dart';
// import 'package:esthetic_match/app/utils/extensions/flush_bar_extension.dart';
// import 'package:esthetic_match/app/utils/service_error_handler.dart';
// import 'package:esthetic_match/model/doctor/doctor_model.dart';
// import 'package:esthetic_match/model/general/procedure_catalog.dart';
// import 'package:esthetic_match/model/user/user_model.dart';
// import 'package:esthetic_match/provider/auth/locale_provider.dart';
// import 'package:esthetic_match/provider/home/navigation_provider.dart';
// import 'package:esthetic_match/repository/doctor/doctor_auth_repo.dart';
// import 'package:esthetic_match/repository/user/user_auth_repo.dart';
// import 'package:esthetic_match/services/common/session_manager/session_controller.dart';
// import 'package:esthetic_match/view/auth/widgets/email_verification_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';

class AuthService {
  static void gotoProfileTypeSelection(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesName.profileTypeSelection);
  }

  static void gotoLogin(BuildContext context, bool isVendor) {
    Navigator.pushNamed(
      context,
      arguments: {'isVendor': isVendor},
      RoutesName.login,
    );
  }

  static void gotoSignup(BuildContext context, bool isVendor) {
    Navigator.pushNamed(
      context,
      isVendor ? RoutesName.vendorSignup : RoutesName.userSignup,
    );
  }

  static void gotoForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.forgotPassword);
  }

  static void gotoNewPassword(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.newPassword);
  }

  static void gotoVendorHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.vendorHome,
      (route) => false,
    );
  }

  static void gotoUserHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.userHome,
      (route) => false,
    );
  }

  static void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.profileTypeSelection,
      (route) => false,
    );
  }

  static void gotoChangePassword(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.changePassword);
  }

  // final UserAuthRepository _userAuth = UserAuthRepository();
  // final DoctorAuthRepository _docAuth = DoctorAuthRepository();
  // final SessionController _session = SessionController();
  // static const String tag = 'AuthService';

  // Future<void> getAllProcedures(
  //   BuildContext? context, {
  //   required String locale,
  // }) async {
  //   try {
  //     final response = await _docAuth.getAllProcedures(locale);
  //     await _session.saveProcedures((response['procedures'] as List<dynamic>)
  //         .map((e) => ProcedureCatalogModel.fromJson(e as Map<String, dynamic>))
  //         .toList());
  //     await _session.saveMedicalSpecialty((response['medical_speciality']
  //             as List<dynamic>)
  //         .map((e) => MedicalSpecialtyModel.fromJson(e as Map<String, dynamic>))
  //         .toList());
  //     debugPrint('[$tag] ✅ Fetched all procedures');
  //   } catch (e) {
  //     ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> userLogin(
  //   BuildContext context, {
  //   required String email,
  //   required String password,
  // }) async {
  //   final data = {'email': email, 'password': password};

  //   try {
  //     final response = await _userAuth.login(data);
  //     final token = response['token'] as String;
  //     final userData = response['user'] as Map<String, dynamic>;

  //     await _session.saveToken(token);
  //     await _session.saveUser(UserModel.fromJson(userData));
  //     _session.userType = UserType.user;
  //     await _session.saveUserType();
  //     if (context.mounted) {
  //       goToHome(context);
  //     }
  //     debugPrint('[$tag] ✅ User login success');
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> doctorLogin(
  //   BuildContext context, {
  //   required String email,
  //   required String password,
  // }) async {
  //   final data = {'email': email, 'password': password};

  //   try {
  //     final response = await _docAuth.login(data);
  //     final token = response['token'] as String;
  //     final docData = response['doctor'] as Map<String, dynamic>;

  //     await _session.saveToken(token);
  //     await _session.saveDoctor(DoctorModel.fromJson(docData));
  //     _session.userType = UserType.doctor;
  //     await _session.saveUserType();
  //     if (context.mounted) {
  //       goToHome(context);
  //     }

  //     debugPrint('[$tag] ✅ Doctor login success');
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> userSignup(
  //   BuildContext context, {
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     final response = await _userAuth.signup(data);

  //     if (context.mounted) {
  //       context.flushBarSuccessMessage(message: response['message'] as String);
  //       await showUserEmailVerificationSheet(
  //         context,
  //         email: data['email'] as String,
  //       );
  //     }

  //     // debugPrint('[$tag] ✅ User signup success');
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> doctorSignup(
  //   BuildContext context, {
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     final response = await _docAuth.signup(data);

  //     if (context.mounted) {
  //       context.flushBarSuccessMessage(message: response['message'] as String);
  //       await showUserEmailVerificationSheet(
  //         context,
  //         isDoctor: true,
  //         email: data['email'] as String,
  //       );
  //     }

  //     // debugPrint('[$tag] ✅ Doctor signup success');
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<bool> sendOtp({
  //   required BuildContext context,
  //   required String email,
  //   // required String type,
  //   bool isDoctor = false,
  // }) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'email': email,
  //       // 'type': type, // 'signup' or 'forgot_password'
  //     };
  //     isDoctor ? await _docAuth.signupOtp(data) : await _userAuth.sendOtp(data);
  //     if (context.mounted) {
  //       context.flushBarSuccessMessage(message: 'OTP sent to your email...');
  //     }
  //     return true;
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  //   return false;
  // }

  // Future<bool> sendForgotOtp({
  //   required BuildContext context,
  //   required String email,
  //   bool isDoctor = false,
  // }) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'email': email,
  //     };
  //     isDoctor
  //         ? await _docAuth.forgotPassword(data)
  //         : await _userAuth.forgotPassword(data);
  //     if (context.mounted) {
  //       context.flushBarSuccessMessage(message: 'OTP sent to your email...');
  //     }
  //     return true;
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  //   return false;
  // }

  // Future<void> verifyOtp({
  //   required BuildContext context,
  //   required String email,
  //   required String otp,
  //   required bool isDoctor,
  // }) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'email': email,
  //       'otp': otp,
  //     };

  //     if (isDoctor) {
  //       final response = await _docAuth.verifyOtp(data);
  //       final token = response['token'] as String;
  //       final docData = response['doctor'] as Map<String, dynamic>;

  //       await _session.saveToken(token);
  //       await _session.saveDoctor(DoctorModel.fromJson(docData));
  //       _session.userType = UserType.doctor;
  //       await _session.saveUserType();
  //     } else {
  //       final response = await _userAuth.verifyOtp(data);
  //       final token = response['token'] as String;
  //       final userData = response['user'] as Map<String, dynamic>;

  //       await _session.saveToken(token);
  //       await _session.saveUser(UserModel.fromJson(userData));
  //       _session.userType = UserType.user;
  //       await _session.saveUserType();
  //     }

  //     if (context.mounted) {
  //       Navigator.of(context).pop();
  //       isDoctor ? goToDoctorOnBoarding(context) : goToHome(context);
  //     }
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> verifyForgotOtp({
  //   required BuildContext context,
  //   required String email,
  //   required String otp,
  //   required bool isDoctor,
  // }) async {
  //   final data = {'email': email, 'otp': otp};
  //   try {
  //     isDoctor
  //         ? await _docAuth.verifyOtp(data)
  //         : await _userAuth.verifyOtp(data);

  //     await goToResetPasswordScreen(
  //       context,
  //       otp: otp,
  //       email: email,
  //       isDoctor: isDoctor,
  //     );
  //   } catch (e) {
  //     if (context.mounted) {
  //       ErrorHandler.handle(context, e, serviceName: tag);
  //     }
  //   }
  // }

  // Future<void> resetPassword({
  //   required BuildContext context,
  //   required String email,
  //   required String otp,
  //   required String newPassword,
  //   bool isDoctor = false,
  // }) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'email': email,
  //       'otp': otp,
  //       'newPassword': newPassword,
  //     };
  //     isDoctor
  //         ? await _docAuth.resetPassword(data)
  //         : await _userAuth.resetPassword(data);

  //     if (context.mounted) {
  //       goToLogin(context, isDoctor: isDoctor);
  //     }
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //   }
  // }

  // Future<void> fetchProfile(BuildContext? context) async {
  //   try {
  //     if (_session.userType == UserType.user) {
  //       debugPrint('[$tag] Fetching user profile');
  //       final response = await _userAuth.getCurrentUserProfile();
  //       await _session.saveUser(
  //         UserModel.fromJson(
  //           response['user'] as Map<String, dynamic>,
  //         ),
  //       );
  //     } else if (_session.userType == UserType.doctor) {
  //       debugPrint('[$tag] Fetching doctor profile');
  //       final response = await _docAuth.getCurrentDocProfile();
  //       await _session.saveDoctor(
  //         DoctorModel.fromJson(
  //           response['doctor'] as Map<String, dynamic>,
  //         ),
  //       );

  //       if (_session.procedures == null ||
  //           _session.procedures!.isEmpty ||
  //           _session.medicalSpecialty == null ||
  //           _session.medicalSpecialty!.isEmpty) {
  //         await getAllProcedures(
  //           context,
  //           locale: LocaleNotifier().locale.languageCode,
  //         );
  //       }
  //     }
  //     debugPrint('[$tag] ✅ Profile fetched');
  //   } catch (e) {
  //     ErrorHandler.handle(context, e, serviceName: tag);
  //     rethrow;
  //   }
  // }

  // Future<void> checkAuthentication(BuildContext context) async {
  //   if (_session.isLoggedIn && _session.userType != null) {
  //     debugPrint('[$tag] Active session found, fetching profile');
  //     try {
  //       await fetchProfile(context);
  //       if (context.mounted) goToHome(context);
  //     } catch (_) {
  //       debugPrint('[$tag] Error fetching profile, clearing session');
  //       await _session.clearSession();
  //       if (context.mounted) goToWelcome(context);
  //     }
  //   } else {
  //     debugPrint(
  //         '[$tag] No active session found, redirecting to welcome screen');
  //     Timer(const Duration(seconds: 1), () {
  //       if (context.mounted) goToWelcome(context);
  //     });
  //   }
  // }

  // Future<void> logout(BuildContext context) async {
  //   await _session.clearSession();
  //   if (context.mounted) {
  //     goToWelcome(context);
  //   }
  //   debugPrint('[$tag] Logged out');
  // }

  // static void goToForgotPassword(
  //   BuildContext context, {
  //   bool isDoctor = false,
  // }) {
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.forgetPassword,
  //     arguments: {'isDoctor': isDoctor},
  //   );
  // }

  // static void goToHome(BuildContext context) {
  //   context.read<NavigationProvider>().setIndex(0);
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     RoutesName.navigation,
  //     (route) => false,
  //   );
  // }

  // static Future<void> goToAccountTypeScreen(
  //   BuildContext context, {
  //   bool isLogin = false,
  // }) async {
  //   await Navigator.pushNamed(
  //     context,
  //     RoutesName.accountType,
  //     arguments: {'isLogin': isLogin},
  //   );
  // }

  // static Future<void> goToForgotPasswordScreen(
  //   BuildContext context, {
  //   bool isDoctor = false,
  // }) async {
  //   await Navigator.pushNamed(
  //     context,
  //     RoutesName.forgetPassword,
  //     arguments: {'isDoctor': isDoctor},
  //   );
  // }

  // static Future<void> goToResetPasswordScreen(
  //   BuildContext context, {
  //   required String otp,
  //   required String email,
  //   bool isDoctor = false,
  // }) async {
  //   await Navigator.pushNamed(
  //     context,
  //     RoutesName.resetPassword,
  //     arguments: {
  //       'isDoctor': isDoctor,
  //       'email': email,
  //       'otp': otp,
  //     },
  //   );
  // }

  // static void goToSignup(
  //   BuildContext context, {
  //   bool isDoctor = false,
  //   bool replace = true,
  // }) {
  //   if (replace) {
  //     Navigator.pushReplacementNamed(
  //       context,
  //       isDoctor ? RoutesName.doctorSignup : RoutesName.userSignup,
  //     );
  //     return;
  //   }
  //   Navigator.pushNamed(
  //     context,
  //     isDoctor ? RoutesName.doctorSignup : RoutesName.userSignup,
  //   );
  // }

  // static void goToLogin(
  //   BuildContext context, {
  //   bool isDoctor = false,
  //   bool replace = true,
  // }) {
  //   if (replace) {
  //     Navigator.pushReplacementNamed(
  //       context,
  //       RoutesName.login,
  //       arguments: {'isDoctor': isDoctor},
  //     );
  //     return;
  //   }
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.login,
  //     arguments: {'isDoctor': isDoctor},
  //   );
  // }

  // static void goToWelcome(BuildContext context) {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     RoutesName.welcome,
  //     (route) => false,
  //   );
  // }

  // static Future<void> goToDoctorOnBoarding(BuildContext context,
  //     {bool showBack = false}) async {
  //   showBack == true
  //       ? await Navigator.pushNamed(
  //           context,
  //           arguments: {'showBack': showBack},
  //           RoutesName.doctorOnboarding,
  //         )
  //       : await Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           arguments: {'showBack': showBack},
  //           RoutesName.doctorOnboarding,
  //           (route) => false,
  //         );
  // }

  // static Future<void> showUserEmailVerificationSheet(
  //   BuildContext context, {
  //   required String email,
  //   // required String type,
  //   bool isDoctor = false,
  // }) async {
  //   await MyBottomSheet.show<void>(
  //     context,
  //     child: EmailVerificationSheet(
  //       email: email,
  //       isDoctor: isDoctor,
  //       // type: type,
  //       context: context,
  //     ),
  //   );
  // }

  // static Future<void> goToAccountVerification(
  //   BuildContext context,
  // ) async {
  //   await Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     RoutesName.accountVerification,
  //     (route) => false,
  //   );
  // }
}
