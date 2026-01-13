import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/utils/app_url.dart';

class VendorNotificationsRepository {
  final BaseApiServices api = NetworkApiService();

  //sendToken
  Future<Map<String, dynamic>> sendToken({
    required String userId,
    required String token,
  }) async {
    return api.post(url: AppUrl.saveTokenVendor, data: {'token': token});
  }

  //sendNotification
  Future<Map<String, dynamic>> sendNotification({
    required String userId, //to which user notification is sent
    required String title,
    required String message,
  }) async {
    return api.post(
      url: AppUrl.pushNotificationVendor,
      data: {'title': title, 'message': message, 'userId': userId},
    );
  }
}
