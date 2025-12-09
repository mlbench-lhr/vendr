import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'vendor_model.g.dart';

@JsonSerializable()
class VendorModel {
  VendorModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.vendorType,
    this.id,
    this.verified,
    this.profileImage,
    this.address,
    this.routes,
    this.location,
    this.menu,
    this.hours,
    this.hoursADay,
    this.provider,
    this.reviews,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);

  // ------------------------
  // Vendor Fields
  // ------------------------

  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String email;
  final String phone;

  @JsonKey(name: 'vendor_type')
  final String vendorType;

  final String? provider;
  final bool? verified;

  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @JsonKey(name: 'shop_address')
  final String? address;

  final List<Map<String, dynamic>>? routes;

  // Hours (nested)
  final HoursModel? hours;

  final String? hoursADay;

  // Location mapping from JSON → LatLng
  @JsonKey(fromJson: _latLngFromJson, toJson: _latLngToJson)
  final LatLng? location;

  // Menus array from API
  @JsonKey(name: 'menus')
  final List<MenuItemModel>? menu;

  final ReviewsModel? reviews;

  // ------------------------
  // LatLng Converters
  // ------------------------

  static LatLng? _latLngFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return LatLng(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    );
  }

  static Map<String, dynamic>? _latLngToJson(LatLng? v) {
    if (v == null) return null;
    return {"lat": v.latitude, "lng": v.longitude};
  }
}

//
// -----------------------------
//      MenuItemModel
// -----------------------------
//

@JsonSerializable()
class MenuItemModel {
  MenuItemModel({
    this.itemId,
    required this.itemName,
    this.itemDescription,
    required this.servings,
    this.category,
    this.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  @JsonKey(name: '_id')
  final String? itemId;

  @JsonKey(name: 'name')
  final String itemName;

  @JsonKey(name: 'description')
  final String? itemDescription;

  @JsonKey(name: 'category')
  final String? category;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'servings')
  final List<ServingModel> servings;
}

//
// -----------------------------
//      ServingModel
// -----------------------------
//

@JsonSerializable()
class ServingModel {
  ServingModel({required this.servingQuantity, required this.servingPrice});

  factory ServingModel.fromJson(Map<String, dynamic> json) =>
      _$ServingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServingModelToJson(this);

  @JsonKey(name: 'serving')
  final String servingQuantity;

  @JsonKey(name: 'price')
  final String servingPrice;
}

//
// -----------------------------
//      HoursModel
// -----------------------------
//

@JsonSerializable()
class HoursModel {
  HoursModel({required this.days});

  factory HoursModel.fromJson(Map<String, dynamic> json) =>
      _$HoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$HoursModelToJson(this);

  final Days days;
}

@JsonSerializable()
class Days {
  Days({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory Days.fromJson(Map<String, dynamic> json) => _$DaysFromJson(json);

  Map<String, dynamic> toJson() => _$DaysToJson(this);

  final DayHours monday;
  final DayHours tuesday;
  final DayHours wednesday;
  final DayHours thursday;
  final DayHours friday;
  final DayHours saturday;
  final DayHours sunday;
}

@JsonSerializable()
class DayHours {
  DayHours({required this.enabled, required this.start, required this.end});

  factory DayHours.fromJson(Map<String, dynamic> json) =>
      _$DayHoursFromJson(json);

  Map<String, dynamic> toJson() => _$DayHoursToJson(this);

  final bool enabled;
  final String start;
  final String end;
}

//
// -----------------------------
//      ReviewsModel
// -----------------------------
//

class ReviewsModel {
  final double averageRating;
  final int totalReviews;
  final List<Map<String, dynamic>> list;

  ReviewsModel({
    required this.averageRating,
    required this.totalReviews,
    required this.list,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      list: (json['list'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'list': list,
    };
  }
}
