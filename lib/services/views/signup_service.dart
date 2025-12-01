import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/data/exception/app_exceptions.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/repository/auth_repo.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/view/auth/widgets/account_verification_sheet.dart';

class SignupService {
  final AuthRepository _authRepository = AuthRepository();
  final SessionController _sessionController = SessionController();

  static void showVerificationSheet(
    BuildContext context, {
    required String email,
  }) {
    MyBottomSheet.show<void>(
      context,
      isDismissible: false,
      backgroundColor: context.colors.cardPrimary,
      child: AccountVerificationSheet(email: email),
    );
  }

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
        'phone': password,
        'vendor_type': vendorType,
        'password': password,
      };

      // final response =
      await _authRepository.vendorSignup(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Signup successful!');
        showVerificationSheet(context, email: email);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SignupService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SignupService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'otp': otp};
      final response = await _authRepository.verifyOtp(data);
      final String accessToken = response['tokens']['accessToken'] as String;
      final String refreshToken = response['tokens']['refreshToken'] as String;
      // final Map<String, dynamic> userData =
      //     response['user'] as Map<String, dynamic>;

      // //save token in session controller
      await _sessionController.saveToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
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
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SignupService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SignupService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }
}
