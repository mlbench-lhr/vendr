import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/utils/app_url.dart';

class UserNotificationsRepository {
  final BaseApiServices api = NetworkApiService();

  //sendToken
  Future<Map<String, dynamic>> sendToken({
    required String userId,
    required String token,
  }) async {
    return api.post(url: AppUrl.saveTokenUser, data: {'token': token});
  }

  //sendNotification
  Future<Map<String, dynamic>> sendNotification({
    required String doctorId, //to which doctor notification is sent
    required String title,
    required String message,
  }) async {
    return api.post(
      url: AppUrl.pushNotificationUser,
      data: {'title': title, 'message': message, 'doctorId': doctorId},
    );
  }
}
