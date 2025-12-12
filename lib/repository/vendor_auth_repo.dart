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

  //Resend OTP
  Future<Map<String, dynamic>> resendSignupOtp(
    Map<String, dynamic> data,
  ) async {
    return _apiServices.post(url: AppUrl.resendOtp, data: data);
  }

  //Profile management
  Future<Map<String, dynamic>> updateVendorProfile(
    Map<String, dynamic> data,
  ) async {
    return _apiServices.put(url: AppUrl.vendorProfileUpdate, data: data);
  }

  Future<Map<String, dynamic>> updateVendorHours(
    Map<String, dynamic> data,
  ) async {
    return _apiServices.put(url: AppUrl.vendorHoursUpdate, data: data);
  }

  //Upload product
  Future<Map<String, dynamic>> uploadProduct(Map<String, dynamic> data) async {
    return _apiServices.post(url: AppUrl.uploadProduct, data: data);
  }

  //Upload product
  Future<Map<String, dynamic>> editProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    return _apiServices.post(
      url: '${AppUrl.editProduct}$productId',
      data: data,
    );
  }

  //fetch profile
  Future<Map<String, dynamic>> getCurrentVendorProfile() async {
    return _apiServices.get(url: AppUrl.getVendorProfile);
  }

  //fetch profile
  Future<Map<String, dynamic>> getReviews({String query = ''}) async {
    return _apiServices.get(url: '${AppUrl.getVendorReviews}?$query');
  }

  //delete product
  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    return _apiServices.delete(url: '${AppUrl.deleteProduct}/$productId');
  }

  //delete product
  Future<Map<String, dynamic>> deleteVendorAccount() async {
    return _apiServices.delete(url: AppUrl.deleteVendorAccount);
  }
}
