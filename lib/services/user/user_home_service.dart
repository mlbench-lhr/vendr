import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendr/app/network/base_api_services.dart';
import 'package:vendr/app/network/network_api_services.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/user_home_repo.dart';
import 'package:vendr/services/common/auth_service.dart';
import 'package:vendr/repository/user_auth_repo.dart';

class UserHomeService {
  final String tag = '[UserHomeService]';
  final BaseApiServices api = NetworkApiService();
  final UserHomeRepository _userHomeRepo = UserHomeRepository();

  ///
  ///gotoNotifications
  ///

  final _userAuthRepo = UserAuthRepository();
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

      final queryString = api.buildQueryString(queryParams);

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
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
    }
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

  //go to vendor search

  // Search Vendors Service
  Future<List<VendorModel>> searchVendors({
    required BuildContext context,
    required String query,
    required LatLng userLocation,
    double searchRadius = 5,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'lat': userLocation.latitude,
        'lng': userLocation.longitude,
        'distance': searchRadius,
      };

      final queryString = api.buildQueryString(queryParams);

      // final response = await _userAuthRepo.searchVendors(query: query);
      final response = await _userAuthRepo.searchVendors(
        queryString: queryString,
      );

      if (response['success'] == true) {
        final vendors = response['vendors'] as List<dynamic>? ?? [];
        return vendors
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      // ignore: use_build_context_synchronously
      ErrorHandler.handle(context, e, serviceName: 'SearchVendorService');
      return [];
    }
  }
}
