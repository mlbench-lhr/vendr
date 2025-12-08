import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/vendor_auth_repo.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class VendorProfileService {
  String tag = '[Vendor Profile Service]';
  final _sessionController = SessionController();
  final _vendorAuthRepo = VendorAuthRepository();

  static void gotoVendorMyMenu(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorMyMenu);
  }

  static void gotoVendorEditProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorEditProfile);
  }

  static void gotoVendorHours(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorHours);
  }

  static void gotoVendorLocation(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorLocation);
  }

  static void gotoLanguagesScreen(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.languages);
  }

  static void gotoChangePhoneNumber(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorChangePhoneNumber);
  }

  static void gotoChangeEmail(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorChangeEmail);
  }

  static void gotoVendorAddProduct(BuildContext context, bool isEdit) {
    Navigator.pushNamed(
      context,
      arguments: {'isEdit': isEdit},
      RoutesName.vendorAddEditProduct,
    );
  }

  ///
  ///Update Vendor Profile
  ///
  Future<void> updateVendorProfile(
    BuildContext context, {
    String? name,
    String? imageUrl,
    String? vendorType,
    String? shopAddress,
    VoidCallback? onSuccess,
  }) async {
    final Map<String, dynamic> data = {
      'name': name,
      'profile_image': imageUrl,
      'vendor_type': vendorType,
      'shop_address': shopAddress,
    };
    try {
      final response = await _vendorAuthRepo.updateVendorProfile(data);
      await _sessionController.saveVendor(
        VendorModel.fromJson(response['vendor'] as Map<String, dynamic>),
      );
      onSuccess?.call();
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Update Vendor Hours
  ///
  Future<void> updateVendorHours(
    BuildContext context,
    Map<String, dynamic> data,
    VoidCallback? onSuccess,
  ) async {
    try {
      final response = await _vendorAuthRepo.updateVendorHours(data);
      await _sessionController.saveVendor(
        VendorModel.fromJson(response['vendor'] as Map<String, dynamic>),
      );
      onSuccess?.call();
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Add/Edit Product/Menu Item
  ///
  Future<void> editOrUploadProduct(
    BuildContext context, {
    bool isEdit = false,
    String? productId, //optional only if edit
    String? productName,
    String? imageUrl,
    String? category,
    String? description,
    List<Map<String, dynamic>>? servings,
    VoidCallback? onSuccess,
  }) async {
    final Map<String, dynamic> data = {
      'name': productName,
      'category': category,
      'servings': servings,
      'description': description,
      'image': imageUrl,
    };
    try {
      isEdit
          ? await _vendorAuthRepo.editProduct(productId!, data)
          : await _vendorAuthRepo.uploadProduct(data);
      onSuccess?.call();
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }
}
