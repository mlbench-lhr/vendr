import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/user_home_repo.dart';
import 'package:vendr/services/common/auth_service.dart';

class UserHomeService {
  final String tag = '[UserHomeService]';
  final UserHomeRepository _userHomeRepo = UserHomeRepository();

  ///
  ///gotoNotifications
  ///
  static void gotoNotifications(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.notificationScreen);
  }

  ///
  ///gotoSearch
  ///
  static void gotoSearch(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.userSearch);
  }

  ///
  ///gotoVendorMenu
  ///
  static void gotoVendorMenu(BuildContext context, List<MenuItemModel>? menu) {
    Navigator.pushNamed(
      context,
      arguments: {'menu': menu},
      RoutesName.userMenu,
    );
  }

  ///
  ///_buildQueryString
  ///
  String _buildQueryString(Map<String, dynamic> params) {
    final queryParts = <String>[];

    params.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        queryParts.add('$key=${Uri.encodeQueryComponent(value.toString())}');
      }
    });

    return queryParts.isEmpty ? '' : queryParts.join('&');
  }

  // Future<List<VendorModel>> getNearbyVendors({
  //   required BuildContext context,
  //   required LatLng? location,
  //   maxDistance = 5, //kilometers
  // }) async {
  //   if (location == null) {
  //     debugPrint('❌ User location is null');
  //     return [];
  //   }
  //   try {
  //     final queryParams = {
  //       if (location != LatLng(0, 0)) 'lat': location.latitude,
  //       'lng': location.longitude,
  //       'maxDistance': maxDistance,
  //       if (maxDistance != null) 'maxDistance': maxDistance,
  //     };
  //     // Build query string
  //     final queryString = _buildQueryString(queryParams);
  //     final response = await _userHomeRepo.getNearbyVendors(query: queryString);
  //     debugPrint('✅ Nearby vendors fetch successfully!');
  //     return response['vendors'];
  //   } catch (e) {
  //     if (context.mounted) {
  //       ErrorHandler.handle(context, e, serviceName: tag);
  //     }
  //     return [];
  //   }
  // }

  ///
  ///getNearbyVendors
  ///
  Future<List<VendorModel>> getNearbyVendors({
    required BuildContext context,
    required LatLng? location,
    double maxDistance = 5, // kilometers
  }) async {
    if (location == null) {
      debugPrint('❌ User location is null');
      return [];
    }

    try {
      final queryParams = {
        'lat': location.latitude,
        'lng': location.longitude,
        'maxDistance': maxDistance,
      };

      final queryString = _buildQueryString(queryParams);

      final response = await _userHomeRepo.getNearbyVendors(query: queryString);

      debugPrint('✅ Nearby vendors fetched successfully!');

      // --- IMPORTANT PART ---
      // Convert list<dynamic> → List<VendorModel>
      if (response['vendors'] is List) {
        return (response['vendors'] as List)
            .map((json) => VendorModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return [];
    }
  }

  ///
  ///getVendorDetails
  ///
  Future<VendorModel?> getVendorDetails({
    required BuildContext context,
    required String vendorId,
  }) async {
    try {
      final response = await _userHomeRepo.getVendorDetails(vendorId: vendorId);
      debugPrint('vendor deails $response');
      debugPrint('✅ Vendor Details fetched successfully!');

      return VendorModel.fromJson(response['vendor']);
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return null;
    }
  }

  static void gotoReviews(
    BuildContext context, {
    bool isVendor = true,
    required String vendorId,
  }) {
    Navigator.pushNamed(
      context,
      arguments: {'isVendor': isVendor, 'vendorId': vendorId},
      RoutesName.reviews,
    );
  }

  ///
  ///getVendorReviews
  ///
  Future<ReviewsModel?> getVendorReviews(
    BuildContext context, {
    required String vendorId,
  }) async {
    try {
      //TODO: pagination
      final response = await _userHomeRepo.getVendorReviews(
        vendorId: vendorId,
        query: '?page=1&limit=99',
      ); //pagination will be later
      return ReviewsModel.fromJson(response);
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return null;
    }
  }

  ///
  ///addToFavorites
  ///
  Future<void> addToFavorites(
    BuildContext context, {
    required String vendorId,
  }) async {
    try {
      await _userHomeRepo.addToFavorites(vendorId: vendorId);
      if (context.mounted) {
        await AuthService().fetchProfile(context);
      }
      // if (context.mounted) {
      //   context.flushBarSuccessMessage(message: 'Vendor added to favorites');
      // }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
    }
  }
}
