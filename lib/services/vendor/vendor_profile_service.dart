import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/vendor_auth_repo.dart';
import 'package:vendr/services/common/auth_service.dart';
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

  static void gotoAddEditProduct(
    BuildContext context,
    bool isEdit,
    MenuItemModel? product,
  ) {
    Navigator.pushNamed(
      context,
      arguments: {'isEdit': isEdit, if (isEdit) 'product': product},
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
    double? lat,
    double? lng,
    VoidCallback? onSuccess,
  }) async {
    final VendorModel? vendor = _sessionController.vendor;

    final Map<String, dynamic> data = {
      if (name != null && vendor?.name != name) 'name': name,
      if (imageUrl != null && vendor?.profileImage != imageUrl)
        'profile_image': imageUrl,
      if (vendorType != null && vendor?.vendorType != vendorType)
        'vendor_type': vendorType,
      if (shopAddress != null && vendor?.address != shopAddress)
        'shop_address': shopAddress,
      if (lat != null && vendor?.lat != lat) 'lat': lat,
      if (lng != null && vendor?.lng != lng) 'lng': lng,
    };
    try {
      await _vendorAuthRepo.updateVendorProfile(data);

      if (context.mounted) {
        await AuthService().fetchProfile(context);
      }

      // await _sessionController.saveVendor(
      //   VendorModel.fromJson(response['vendor'] as Map<String, dynamic>),
      // );
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
      await _vendorAuthRepo.updateVendorHours(data);
      if (context.mounted) {
        AuthService().fetchProfile(context);
      }
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
      'image_url': imageUrl,
      // 'image': imageUrl,
    };

    try {
      isEdit
          ? await _vendorAuthRepo.editProduct(productId!, data)
          : await _vendorAuthRepo.uploadProduct(data);
      if (context.mounted) {
        await AuthService().fetchProfile(context);
      }
      onSuccess?.call();
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }

  ///
  ///Delete Product/Menu Item
  ///
  Future<void> deleteProduct(
    BuildContext context, {
    required String productId,
    VoidCallback? onSuccess,
  }) async {
    try {
      await _vendorAuthRepo.deleteProduct(productId);
      if (context.mounted) {
        await AuthService().fetchProfile(context);
      }
      onSuccess?.call();
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
    }
  }
}
