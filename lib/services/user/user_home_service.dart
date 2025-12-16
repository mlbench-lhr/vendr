import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/user_auth_repo.dart';

class UserHomeService {
  String tag = '[User Home Service]';
  final _userAuthRepo = UserAuthRepository();
  static void gotoNotifications(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.notificationScreen);
  }

  static void gotoSearch(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userSearch);
  }

  static void gotoVendorMenu(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userMenu);
  }

  // Add User Review
  Future<void> submitReview({
    required BuildContext context,
    required String message,
    required String vendorId,
    required int rating,
  }) async {
    try {
      final data = {
        'message': message,
        'rating': rating,
        'vendor_id': vendorId,
      };
      await _userAuthRepo.addUserReview(data);
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
    }
  }

  // Search Vendors Service
  Future<List<VendorModel>> searchVendor({
    required BuildContext context,
    required String query,
  }) async {
    try {
      // Skip API call if query is empty
      if (query.trim().isEmpty) return [];

      final response = await _userAuthRepo.searchVendors(query: query);

      if (response['success'] == true) {
        final vendors = response['vendors'] as List<dynamic>? ?? [];
        return vendors
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      ErrorHandler.handle(context, e, serviceName: 'SearchVendorService');
      return [];
    }
  }
}
