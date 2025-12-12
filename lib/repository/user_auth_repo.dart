import 'package:flutter/cupertino.dart';
import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/utils/app_url.dart';
// import 'package:vendr/services/common/session_manager/session_controller.dart';

class UserAuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  // final SessionController _sessionController = SessionController();

  Future<Map<String, dynamic>> userSignup(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.userSignup, data: data);
  }

  Future<Map<String, dynamic>> updateuserProfile(
    Map<String, dynamic> data,
  ) async {
    return _apiServices.put(url: AppUrl.userProfileUpdate, data: data);
  }

  Future<Map<String, dynamic>> userLogin(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.userLogin, data: data);
  }

  //fetch profile
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    return _apiServices.get(url: AppUrl.getUserProfile);
  }

  Future<Map<String, dynamic>> verifySignupOtp(
    Map<String, dynamic> data,
  ) async {
    debugPrint('verifyOtp called with data: $data'); //#muttas
    return _apiServices.post(url: AppUrl.verifyUserOtp, data: data);
  }

  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.forgotPassword, data: data);
  }

  Future<Map<String, dynamic>> verifyPasswordOtp(
    Map<String, dynamic> data,
  ) async {
    return _apiServices.post(url: AppUrl.verifyOtp, data: data);
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.resetPassword, data: data);
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.changePassword, data: data);
  }

  // Delete User Account
  Future<Map<String, dynamic>> deleteUserAccount() async {
    return _apiServices.delete(url: AppUrl.deleteUserAccount);
  }
}
