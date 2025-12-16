import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  static void gotoForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.forgotPassword);
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

  static void goToWelcome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.welcome,
      (route) => false,
    );
  }

  static void logout(BuildContext context) async {
    await SessionController().clearSession();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.profileTypeSelection,
        (route) => false,
      );
    }
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
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'phone': phone,
        'vendor_type': vendorType,
        'password': password,
      };

      // final response =
      await _vendorAuthRepo.vendorSignup(data);

      if (context.mounted) {
        // context.flushBarSuccessMessage(message: 'Signup successful!');
        showVerificationSheet(context, email: email, isVendor: true);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
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

      if (context.mounted) {
        // context.flushBarSuccessMessage(message: 'Signup successful!');
        showVerificationSheet(context, email: email, isVendor: false);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
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
      final Map<String, dynamic> data = {'email': email, 'otp': otp};

      if (isVendor) {
        //Vendor Side
        final response = await _vendorAuthRepo.verifySignupOtp(data);
        final String accessToken = response['tokens']['accessToken'] as String;
        final String refreshToken =
            response['tokens']['refreshToken'] as String;
        final Map<String, dynamic> vendorData =
            response['vendor'] as Map<String, dynamic>;

        await _sessionController.saveVendor(VendorModel.fromJson(vendorData));

        //save token in session controller
        await _sessionController.saveToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        //User Side
        final response = await _userAuthRepo.verifySignupOtp(data);
        final String accessToken = response['tokens']['accessToken'] as String;
        final String refreshToken =
            response['tokens']['refreshToken'] as String;
        final Map<String, dynamic> userData =
            response['user'] as Map<String, dynamic>;
        await _sessionController.saveUser(UserModel.fromJson(userData));
        //save token in session controller
        await _sessionController.saveToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

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
      if (context.mounted) {
        isVendor ? goToVendorHome(context) : goToUserHome(context);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
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
      if (context.mounted) {
        await fetchProfile(context);
      }
      if (context.mounted) {
        goToUserHome(context);
      }
      debugPrint('[$tag] ✅ User login success');
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
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
      final vendorData = response['vendor'] as Map<String, dynamic>;

      await _sessionController.saveToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await _sessionController.saveVendor(VendorModel.fromJson(vendorData));
      _sessionController.userType = UserType.vendor;
      await _sessionController.saveUserType();
      if (context.mounted) {
        await fetchProfile(context);
      }
      if (context.mounted) {
        goToVendorHome(context);
      }
      debugPrint('[$tag] ✅ Vendor login success');
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
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
        final response = await _vendorAuthRepo.getCurrentVendorProfile();
        await _sessionController.saveVendor(
          VendorModel.fromJson(response['vendor'] as Map<String, dynamic>),
        );
      }
      debugPrint('[$tag] ✅ Profile fetched');
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      rethrow;
    }
  }

  ///
  ///Check Authentication
  ///

  Future<void> checkAuthentication(BuildContext context) async {
    if (_sessionController.isLoggedIn && _sessionController.userType != null) {
      debugPrint('[$tag] Active session found, fetching profile');
      try {
        await fetchProfile(context);
        if (context.mounted) {
          _sessionController.userType == UserType.user
              ? goToUserHome(context)
              : goToVendorHome(context);
        }
      } catch (_) {
        debugPrint('[$tag] Error fetching profile, clearing session');
        await _sessionController.clearSession();
        // if (context.mounted) goToWelcome(context);
      }
    } else {
      debugPrint(
        '[$tag] No active session found, redirecting to welcome screen',
      );
      Timer(const Duration(seconds: 1), () {
        if (context.mounted) goToWelcome(context);
      });
    }
  }

  ///
  ///Send Forgot Otp
  ///
  Future<bool> sendForgotOtp({
    required BuildContext context,
    required String email,
    // bool isDoctor = false,
  }) async {
    try {
      final Map<String, dynamic> data = {'email': email};

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

      if (context.mounted) {
        gotoNewPassword(context, email, otp);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
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
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Change Password
  ///
  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {'old_password': oldPassword, 'new_password': newPassword};
    try {
      await _userAuthRepo.changePassword(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(
          message: 'Password updated successfully.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
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
      }
      if (context.mounted) {
        logout(context);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[$tag] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[$tag] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }

  ///
  ///Google Sign in
  ///
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account == null) return; // user canceled

  //     final GoogleSignInAuthentication auth = await account.authentication;
  //     final idToken = auth.idToken;
  //     final accessToken = auth.accessToken;

  //     // Send these tokens to your backend
  //     await sendGoogleTokenToBackend(idToken, accessToken);
  //   } catch (e) {
  //     print('Google Sign-In Error: $e');
  //   }
  // }

  ///
  ///NEW Google Sign in
  ///

  // Use the official singleton instance (no unnamed constructor).
  final GoogleSignIn _google = GoogleSignIn.instance;

  /// Starts interactive sign-in.
  ///
  /// Returns [GoogleSignInResult] when the user signs-in successfully,
  /// or `null` if the user cancelled the flow.
  ///
  /// Note: `GoogleSignInAccount.authentication` currently only exposes
  /// `idToken`. If you need an access token, call [requestAuthorizationForScopes].
  Future<GoogleSignInResult?> signIn() async {
    // On mobile/desktop the correct entry is `.authenticate()`,
    // which triggers the platform sign-in UI. It returns a GoogleSignInAccount?
    final GoogleSignInAccount? account = await _google.authenticate();

    if (account == null) {
      // user cancelled
      return null;
    }

    // This returns the authentication wrapper (currently contains idToken).
    final GoogleSignInAuthentication auth = await account.authentication;

    return GoogleSignInResult(
      idToken: auth.idToken,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
    );
  }

  //Resend Signup otp
  Future<void> resendSignupOtp(BuildContext context, String email) async {
    final data = {'email': email};
    try {
      await _vendorAuthRepo.resendSignupOtp(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'OTP resent to your email.');
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
    }
  }
  //END: Resend signup otp

  /// Signs out the currently signed-in user (keeps account cached info).
  // Future<void> signOut() => _google.signOut();

  // /// Disconnects the user and clears the local session (removes previous consent).
  // Future<void> disconnect() => GoogleSignIn.instance.disconnect();

  // /// OPTIONAL: Request *authorization* for specific scopes and return the access token.
  // ///
  // /// IMPORTANT: `authentication` provides the *idToken* (identity). Access tokens
  // /// are returned from authorization flows (authorizeScopes).
  // ///
  // /// Example: await requestAuthorizationForScopes(['https://www.googleapis.com/auth/drive']);
  // /// Returns the `accessToken` string on success, or null on failure/user-cancel.
  // Future<String?> requestAuthorizationForScopes(List<String> scopes) async {
  //   // First ensure that the user is signed in
  //   final GoogleSignInAccount? account = GoogleSignIn.instance.currentUser;
  //   if (account == null) {
  //     // you may want to call signIn() before requesting scopes
  //     return null;
  //   }

  //   try {
  //     final GoogleSignInClientAuthorization authorization = await account
  //         .authorizationClient
  //         .authorizeScopes(scopes);
  //     return authorization.accessToken;
  //   } catch (e) {
  //     // user canceled or platform error
  //     return null;
  //   }
  // }

  // /// OPTIONAL: Request a server auth code for server-side token exchange.
  // ///
  // /// This is the correct way to get a one-time code to exchange on your Node backend.
  // /// Returns the server auth code string or null.
  // Future<String?> requestServerAuthCode(List<String> scopes) async {
  //   final GoogleSignInAccount? account = GoogleSignIn.instance.currentUser;
  //   if (account == null) return null;

  //   try {
  //     final GoogleSignInServerAuthorization? serverAuth = await account
  //         .authorizationClient
  //         .authorizeServer(scopes);
  //     return serverAuth?.serverAuthCode;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  //END: Google Sign in

  ///
  ///Apple Sign in
  ///
  // Future<void> signInWithApple() async {
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );

  //   final idToken = credential.identityToken;
  //   final authorizationCode = credential.authorizationCode;

  //   // Send these tokens to your backend
  //   await sendAppleTokenToBackend(idToken, authorizationCode);
  //   debugPrint('🍎 ID TOKEN: $idToken');
  //   debugPrint('🍎 Auth Code: $authorizationCode');
  // }

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
