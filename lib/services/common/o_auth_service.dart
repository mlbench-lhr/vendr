import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendr/app/data/exception/app_exceptions.dart';
import 'package:vendr/app/utils/enums.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/log_manager.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/user_auth_repo.dart';
import 'package:vendr/repository/vendor_auth_repo.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class OAuthService {
  final String tag = 'OAuthService';
  final AuthService _authService = AuthService();
  final UserAuthRepository _userAuthRepo = UserAuthRepository();
  final VendorAuthRepository _vendorAuthRepo = VendorAuthRepository();
  final SessionController _sessionController = SessionController();

  ///
  ///
  ///Google Auth
  ///
  ///

  // 1. Access the singleton instance (No more unnamed constructor)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> googleAuth(
    BuildContext context, {
    required bool isVendor,
  }) async {
    final List<String> scopes = ['email', 'profile'];

    // 2. Trigger Google Authentication (formerly .signIn())
    // Note: authenticate() now throws exceptions instead of returning null on error.
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
      scopeHint: scopes,
    );

    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }

    // 3. Get ID Token (Authentication)
    // In v7+, .authentication is a synchronous getter.
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Missing Google ID Token');
    }

    // 4. Get Access Token (Authorization)
    // Authorization is now separate from Identity. You must request it explicitly.
    final authorization = await googleUser.authorizationClient.authorizeScopes(
      scopes,
    );
    final String? accessToken = authorization.accessToken;

    // 5. Firebase Auth sign-in
    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint('✅ Authentication successful!');
    LogManager.logResponse('✅ Complete Token:', idToken);

    // debugPrint('Email: ${googleUser.email}'); //user email
    // debugPrint('Name: ${googleUser.displayName}'); //user name
    // debugPrint('Photo URL: ${googleUser.photoUrl}'); //user photo url

    //Api call
    if (!context.mounted) return;
    if (isVendor) {
      //vendor oauth
      vendorOAuth(context, providerName: 'google', token: idToken);
    } else {
      //user oauth
      userOAuth(context, providerName: 'google', token: idToken);
    }
  }

  ///
  ///
  ///Apple Auth
  ///
  ///
  Future<void> appleAuth(BuildContext context, {required bool isVendor}) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // This is the data you send to your backend
      // debugPrint('User Identifier: ${credential.userIdentifier}');
      debugPrint('Identity Token: ${credential.identityToken}');
      // debugPrint('Auth Code: ${credential.authorizationCode}');

      final String? idToken = credential.identityToken;
      //Api call
      if (!context.mounted) return;
      if (isVendor) {
        //vendor oauth
        vendorOAuth(context, providerName: 'apple', token: idToken ?? '');
      } else {
        //user oauth
        userOAuth(context, providerName: 'apple', token: idToken ?? '');
      }
      // 4. Send to your OAuth API
    } catch (e) {
      debugPrint('❌ Sign in failed: $e');
    }
  }

  ///
  ///
  ///User OAuth
  ///
  ///

  Future<void> userOAuth(
    BuildContext context, {
    required String providerName, //google / apple
    required String token, //idToken
  }) async {
    try {
      final Map<String, dynamic> data = {
        'provider': providerName,
        'provider_id': token,
      };

      // final response =
      final response = await _userAuthRepo.userOAuth(data);

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
      await _authService.fetchProfile(context);

      if (!context.mounted) return;
      AuthService.goToUserHome(context);
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
  ///
  ///Vendor OAuth
  ///
  ///

  Future<void> vendorOAuth(
    BuildContext context, {
    required String providerName, //google / apple
    required String token, //idToken
  }) async {
    try {
      final Map<String, dynamic> data = {
        'provider': providerName,
        'provider_id': token,
      };

      // final response =
      final response = await _vendorAuthRepo.vendorOAuth(data);

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
      if (!context.mounted) return;
      await _authService.fetchProfile(context);

      if (!context.mounted) return;
      AuthService.goToVendorHome(context);
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
}
