import 'package:flutter/cupertino.dart';
import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/utils/app_url.dart';
// import 'package:vendr/services/common/session_manager/session_controller.dart';

class VendorAuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  // final SessionController _sessionController = SessionController();

  // Authentication
  Future<Map<String, dynamic>> vendorLogin(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.vendorLogin, data: data);
  }

  Future<Map<String, dynamic>> vendorSignup(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.vendorSignup, data: data);
  }

  Future<Map<String, dynamic>> verifySignupOtp(
    Map<String, dynamic> data,
  ) async {
    debugPrint('verifyOtp called with data: $data'); //#muttas
    return _apiServices.post(url: AppUrl.verifyVendorOtp, data: data);
  }
}
