import 'package:flutter/material.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/repository/vendor_auth_repo.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class VendorHomeService {
  String tag = '[Vendor Home Service]';
  final _vendorAuthRepo = VendorAuthRepository();
  static void gotoVendorProfile(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.vendorProfile);
  }

  static void gotoReviews(BuildContext context, {bool isVendor = true}) {
    Navigator.pushNamed(
      context,
      arguments: {'isVendor': isVendor},
      RoutesName.reviews,
    );
  }

  // Future<Map<String, dynamic>> getVendorReviews(
  //   BuildContext context, {
  //   required String productId,
  // }) async {
  //   try {
  //     final response = await _vendorAuthRepo.getReviews();
  //     return response;
  //   } catch (e) {
  //     if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
  //     return {};
  //   }
  // }
  Future<ReviewsModel?> getVendorReviews(BuildContext context) async {
    try {
      //TODO: pagination
      final response = await _vendorAuthRepo.getReviews(
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
  ///getVendorWorkingHoursToday
  ///Returns a String of working hours of vendor "Today"
  ///
  static String getVendorWorkingHoursToday() {
    final VendorModel vendor = SessionController().vendor!;
    final weekday = DateTime.now().weekday;
    // Pick today's schedule automatically
    final day = switch (weekday) {
      DateTime.monday => vendor.hours!.days.monday,
      DateTime.tuesday => vendor.hours!.days.tuesday,
      DateTime.wednesday => vendor.hours!.days.wednesday,
      DateTime.thursday => vendor.hours!.days.thursday,
      DateTime.friday => vendor.hours!.days.friday,
      DateTime.saturday => vendor.hours!.days.saturday,
      DateTime.sunday => vendor.hours!.days.sunday,
      _ => null,
    };

    // Safety checks
    if (day == null || !day.enabled) {
      return "Off";
    }

    final startTime = day.start;
    final endTime = day.end;

    if (!day.enabled) return "Off";

    try {
      // Parse HH:mm
      final s = startTime.split(":");
      final e = endTime.split(":");

      final startMinutes = int.parse(s[0]) * 60 + int.parse(s[1]);
      final endMinutes = int.parse(e[0]) * 60 + int.parse(e[1]);

      if (endMinutes <= startMinutes) return "Off";

      final diff = endMinutes - startMinutes;
      final hours = diff / 60;

      //  Remove .0 for clean printing
      final result = hours % 1 == 0
          ? hours.toInt().toString()
          : hours.toStringAsFixed(1);

      return "$result hours";
    } catch (_) {
      return "Off";
    }
  }
}
