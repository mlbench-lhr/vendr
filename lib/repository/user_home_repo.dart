import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/utils/app_url.dart';

class UserHomeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  //Get notifications (for both user and vendor)
  Future<Map<String, dynamic>> getNotifications() async {
    return _apiServices.get(url: AppUrl.getNotifications);
  }

  Future<Map<String, dynamic>> getNearbyVendors({String query = ''}) async {
    return _apiServices.get(url: '${AppUrl.getNearbyVendors}?$query');
  }

  Future<Map<String, dynamic>> getVendorDetails({
    required String vendorId,
  }) async {
    return _apiServices.get(url: AppUrl.getVendorDetails(vendorId));
  }
}
