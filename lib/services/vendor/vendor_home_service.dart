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
  Future<ReviewsModel?> getVendorReviews({
    required BuildContext context,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _vendorAuthRepo.getReviews(
        query: '?page=$page&limit=$limit',
      );
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
  static String getVendorWorkingHoursToday({HoursModel? vendorHours}) {
    final weekday = DateTime.now().weekday;
    late final HoursModel? hours;

    if (vendorHours != null) {
      hours = vendorHours;
    } else {
      final VendorModel vendor = SessionController().vendor!;
      hours = vendor.hours;
    }

    if (hours == null) return '0 hours';

    final day = switch (weekday) {
      DateTime.monday => hours.days.monday,
      DateTime.tuesday => hours.days.tuesday,
      DateTime.wednesday => hours.days.wednesday,
      DateTime.thursday => hours.days.thursday,
      DateTime.friday => hours.days.friday,
      DateTime.saturday => hours.days.saturday,
      DateTime.sunday => hours.days.sunday,
      _ => null,
    };

    // if (day == null || !day.enabled) return "Off";
    if (day == null || !day.enabled) return "0 hours";

    try {
      final s = day.start.split(":");
      final e = day.end.split(":");

      final startMinutes = int.parse(s[0]) * 60 + int.parse(s[1]);
      final endMinutes = int.parse(e[0]) * 60 + int.parse(e[1]);

      // if (endMinutes <= startMinutes) return "Off";
      if (endMinutes <= startMinutes) return "0 hours";

      final diffMinutes = endMinutes - startMinutes;

      final hoursPart = diffMinutes ~/ 60; // integer hours
      final minutesPart = diffMinutes % 60; // remaining minutes

      if (hoursPart > 0 && minutesPart > 0) {
        return "$hoursPart hours $minutesPart mins";
      } else if (hoursPart > 0) {
        return "$hoursPart hours";
      } else {
        return "$minutesPart mins";
      }
    } catch (_) {
      // return "Off";
      return "0 hours";
    }
  }
}
