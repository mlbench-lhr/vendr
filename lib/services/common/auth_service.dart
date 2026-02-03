import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/data/exception/app_exceptions.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/enums.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/user_auth_repo.dart';
import 'package:vendr/repository/vendor_auth_repo.dart';
import 'package:vendr/services/common/location_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/view/auth/widgets/account_verification_sheet.dart';

class AuthService {
  static const String tag = '[AuthService]';

  final VendorAuthRepository _vendorAuthRepo = VendorAuthRepository();
  final UserAuthRepository _userAuthRepo = UserAuthRepository();
  final SessionController _sessionController = SessionController();

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

  static void gotoForgotPassword(
    BuildContext context, {
    required bool isVendor,
  }) {
    Navigator.pushNamed(
      context,
      arguments: {'isVendor': isVendor},
      RoutesName.forgotPassword,
    );
  }

  static void gotoNewPassword(BuildContext context, String email, String otp) {
    Navigator.pushNamed(
      context,
      arguments: {'email': email, 'otp': otp},
      RoutesName.newPassword,
    );
  }

  static void goToVendorHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.vendorHome,
      (route) => false,
    );
  }

  static void goToUserHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.userHome,
      (route) => false,
    );
  }

  static void goToNoConnectionScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.noConnection,
      (route) => false,
    );
  }

  static void goToWelcome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.welcome,
      (route) => false,
    );
  }

  static void logout(BuildContext context) async {
    await SessionController().clearSession();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.profileTypeSelection,
      (route) => false,
    );
  }

  static void gotoChangePassword(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.changePassword);
  }

  ///
  ///Show Verification Sheet
  ///
  static void showVerificationSheet(
    BuildContext context, {
    required String email,
    required bool isVendor,
  }) {
    MyBottomSheet.show<void>(
      context,
      isDismissible: false,
      isScrollControlled: false,
      enableDrag: false,
      showDragHandle: false,
      backgroundColor: context.colors.cardPrimary,
      child: AccountVerificationSheet(email: email, isVendor: isVendor),
    );
  }

  ///
  ///Vendor Sign Up
  ///
  Future<void> vendorSignup(
    BuildContext context, {
    required String name,
    required String email,
    required String phone,
    required String vendorType,
    required String password,
    required bool hasPermit,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'phone': phone,
        'vendor_type': vendorType,
        'password': password,
        'has_permit': hasPermit,
      };

      // final response =
      await _vendorAuthRepo.vendorSignup(data);

      if (!context.mounted) return;
      // context.flushBarSuccessMessage(message: 'Signup successful!');
      showVerificationSheet(context, email: email, isVendor: true);
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: e.userMessage);
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: 'Something went wrong');
      }
    }
  }

  ///
  ///User Sign Up
  ///
  Future<void> userSignup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'password': password,
      };

      // final response =
      await _userAuthRepo.userSignup(data);

      if (!context.mounted) return;
      // context.flushBarSuccessMessage(message: 'Signup successful!');
      showVerificationSheet(context, email: email, isVendor: false);
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: e.userMessage);
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: 'Something went wrong');
      }
    }
  }

  ///
  ///Verify Otp
  ///
  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
    required bool isVendor,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
        'is_user': !isVendor,
      };

      //TODO:

      if (isVendor) {
        //Vendor Side
        final response = await _vendorAuthRepo.verifySignupOtp(data);
        final String accessToken = response['tokens']['accessToken'] as String;
        final String refreshToken =
            response['tokens']['refreshToken'] as String;
        final Map<String, dynamic> vendorData =
            response['vendor'] as Map<String, dynamic>;

        //save token in session controller
        await _sessionController.saveToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await _sessionController.saveVendor(VendorModel.fromJson(vendorData));
        _sessionController.userType = UserType.vendor;
        await _sessionController.saveUserType();
      } else {
        //User Side
        final response = await _userAuthRepo.verifySignupOtp(data);
        final String accessToken = response['tokens']['accessToken'] as String;
        final String refreshToken =
            response['tokens']['refreshToken'] as String;
        final Map<String, dynamic> userData =
            response['user'] as Map<String, dynamic>;
        //save token in session controller
        await _sessionController.saveToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await _sessionController.saveUser(UserModel.fromJson(userData));
        _sessionController.userType = UserType.user;
        await _sessionController.saveUserType();
      }

      if (!context.mounted) return;
      await fetchProfile(context); //Fetch profile after verification
      // final Map<String, dynamic> userData =
      //     response['user'] as Map<String, dynamic>;

      // //save token in session controller

      // //save user
      // //save user to session #muttas
      // await SessionController().saveUser(
      //   UserModel.fromJson(
      //     userData,
      //   ),
      // );
      // await SessionController().updateUser(
      //   UserModel.fromJson(
      //     userData,
      //   ),
      // );
      // // _sessionController.user.name = verifyResponse['name'] as String;

      // if (context.mounted) {
      //   context.flushBarSuccessMessage(message: 'Account Verified...');
      //   goToOnBoarding(context);
      // }

      //Vendor Login
      if (!context.mounted) return;
      isVendor ? goToVendorHome(context) : goToUserHome(context);
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: e.userMessage);
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: 'Something went wrong');
      }
    }
  }

  ///
  ///User Login
  ///
  Future<void> userLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};

    try {
      final response = await _userAuthRepo.userLogin(data);
      final String accessToken = response['tokens']['accessToken'] as String;
      final String refreshToken = response['tokens']['refreshToken'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      await _sessionController.saveToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await _sessionController.saveUser(UserModel.fromJson(userData));
      _sessionController.userType = UserType.user;
      await _sessionController.saveUserType();
      if (!context.mounted) return;
      await fetchProfile(context);

      if (!context.mounted) return;
      goToUserHome(context);

      debugPrint('[$tag] ✅ User login success');
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Vendor Login
  ///
  Future<void> vendorLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};
    try {
      final response = await _vendorAuthRepo.vendorLogin(data);
      final String accessToken = response['tokens']['accessToken'] as String;
      final String refreshToken = response['tokens']['refreshToken'] as String;
      // Handle both 'vendor' and 'user' keys (API returns vendor data under 'user')
      final vendorData =
          (response['vendor'] ?? response['user']) as Map<String, dynamic>;
      debugPrint(
        '[AuthService] Vendor login - hasPermit from response: ${vendorData['has_permit']}',
      );
      await _sessionController.saveToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await _sessionController.saveVendor(VendorModel.fromJson(vendorData));
      _sessionController.userType = UserType.vendor;
      await _sessionController.saveUserType();
      if (!context.mounted) return;
      await fetchProfile(context);
      if (!context.mounted) return;
      goToVendorHome(context);
      debugPrint('[$tag] ✅ Vendor login success');
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  Future<void> fetchProfile(BuildContext context) async {
    try {
      if (_sessionController.userType == UserType.user) {
        final response = await _userAuthRepo.getCurrentUserProfile();
        await _sessionController.saveUser(
          UserModel.fromJson(response['user'] as Map<String, dynamic>),
        );
      } else if (_sessionController.userType == UserType.vendor) {
        // Preserve existing permit values before fetching new profile
        // because GET /profile doesn't return has_permit and with_permit
        final existingVendor = _sessionController.vendor;
        final existingHasPermit = existingVendor?.hasPermit;
        final existingWithPermit = existingVendor?.withPermit;
        debugPrint(
          '[$tag] fetchProfile - existing hasPermit: $existingHasPermit',
        );

        final response = await _vendorAuthRepo.getCurrentVendorProfile();
        // Handle both 'vendor' and 'user' keys
        final vendorJson =
            (response['vendor'] ?? response['user']) as Map<String, dynamic>;
        debugPrint(
          '[$tag] fetchProfile - API returned hasPermit: ${vendorJson['has_permit']}',
        );

        // Merge preserved permit values if API didn't return them
        if (vendorJson['has_permit'] == null && existingHasPermit != null) {
          vendorJson['has_permit'] = existingHasPermit;
          debugPrint(
            '[$tag] fetchProfile - preserved hasPermit: $existingHasPermit',
          );
        }
        if (vendorJson['with_permit'] == null && existingWithPermit != null) {
          vendorJson['with_permit'] = existingWithPermit;
        }

        await _sessionController.saveVendor(VendorModel.fromJson(vendorJson));
        debugPrint(
          '[$tag] ✅ Profile fetched - final hasPermit: ${_sessionController.vendor?.hasPermit}',
        );
      }
      debugPrint('[$tag] ✅ Profile fetched');
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
      rethrow;
    }
  }

  ///
  ///Check Authentication
  ///
  Future<void> checkAuthentication(BuildContext context) async {
    if (
    // _sessionController.isLoggedIn &&
    _sessionController.userType != null) {
      debugPrint('[$tag] Active session found, fetching profile');
      try {
        await fetchProfile(context);
        if (!context.mounted) return;
        _sessionController.userType == UserType.user
            ? goToUserHome(context)
            : goToVendorHome(context);
      } on SocketException catch (e) {
        // No internet / connection issue
        debugPrint('Socket error: ${e.message}');
        if (!context.mounted) return;
        goToNoConnectionScreen(context);
      } catch (e) {
        debugPrint('Failed to fetch profile: $e');
        debugPrint('[$tag] Error fetching profile, clearing session');
        await _sessionController.clearSession();
        if (!context.mounted) return;
        goToWelcome(context);
        // if (context.mounted) goToWelcome(context);
      }
    } else {
      debugPrint(
        '[$tag] No active session found, redirecting to welcome screen',
      );
      Timer(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        goToWelcome(context);
      });
    }
  }

  ///
  ///Send Forgot Otp
  ///
  Future<bool> sendForgotOtp({
    required BuildContext context,
    required String email,
    required bool isUser,
    // bool isDoctor = false,
  }) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'is_user': isUser};

      //same for both user and vendor
      await _userAuthRepo.forgotPassword(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'OTP sent to your email...');
      }
      return true;
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
    return false;
  }

  ///
  ///Verify Forgot OTP
  ///
  Future<void> verifyForgotOtp({
    required BuildContext context,
    required String email,
    required String otp,
    // required bool isDoctor,
  }) async {
    final data = {'email': email, 'otp': otp};
    try {
      await _userAuthRepo.verifyPasswordOtp(data);

      // await goToResetPasswordScreen(
      //   context,
      //   otp: otp,
      //   email: email,
      //   // isDoctor: isDoctor,
      // );

      if (!context.mounted) return;
      gotoNewPassword(context, email, otp);
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Reset Password
  ///
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String otp,
    required String newPassword,
    bool isDoctor = false,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
        // 'newPassword': newPassword,
      };
      await _userAuthRepo.resetPassword(data);

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Change Password
  ///
  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    VoidCallback? onSuccess,
  }) async {
    final data = {'old_password': oldPassword, 'new_password': newPassword};
    try {
      await _userAuthRepo.changePassword(data);
      if (!context.mounted) return;
      onSuccess?.call();
      context.flushBarSuccessMessage(message: 'Password updated successfully.');
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Delete account
  ///
  Future<void> deleteAccount(
    BuildContext context, {
    required bool isVendor,
  }) async {
    try {
      if (isVendor) {
        await _vendorAuthRepo.deleteVendorAccount();
      } else {
        await _userAuthRepo.deleteUserAccount();
      }
      if (context.mounted) {
        logout(context);
      } else {
        debugPrint('📍 TO BE IMPLEMENTED');
        // await _vendorAuthRepo.deleteUserAccount();
        VendorLocationService().stopSharing();
      }
      if (context.mounted) {
        logout(context);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: e.userMessage);
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (!context.mounted) return;
        context.flushBarErrorMessage(message: 'Something went wrong');
      }
    }
  }

  //Resend Signup otp
  Future<void> resendSignupOtp(BuildContext context, String email) async {
    final data = {'email': email};
    try {
      await _vendorAuthRepo.resendSignupOtp(data);
      if (!context.mounted) return;
      context.flushBarSuccessMessage(message: 'OTP resent to your email.');
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handle(context, e, serviceName: tag);
    }
  }
  //END: Resend signup otp

  ///
  ///
  ///FROM Esthetic
  ///
  ///
  ///
  // final UserAuthRepository _userAuth = UserAuthRepository();
  // final DoctorAuthRepository _docAuth = DoctorAuthRepository();
  // final SessionController _session = SessionController();
  // static const String tag = 'AuthService';

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

//TODO: MOVE THIS TO MODELS
class GoogleSignInResult {
  final String? idToken; // send to backend (verify with Google)
  final String email;
  final String? displayName;
  final String? photoUrl;

  GoogleSignInResult({
    required this.idToken,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });
}
