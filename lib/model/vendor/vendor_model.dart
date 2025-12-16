import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'vendor_model.g.dart';

/// ------------------------------------------------
///                VendorModel
/// ------------------------------------------------
@JsonSerializable()
class VendorModel {
  VendorModel({
    required this.id,
    required this.name,
    required this.vendorType,
    this.email = '',
    this.phone = '',
    this.provider,
    this.verified,
    this.profileImage,
    this.address,
    this.routes,
    this.location,
    this.menu,
    this.hours,
    this.hoursADay,
    this.reviews,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    final model = _$VendorModelFromJson(json);
    return VendorModel(
      id: model.id,
      name: model.name,
      vendorType: model.vendorType,
      email: model.email,
      phone: model.phone,
      provider: model.provider,
      verified: model.verified,
      profileImage: model.profileImage,
      address: model.address,
      routes: model.routes,
      menu: model.menu,
      hours: model.hours,
      hoursADay: model.hoursADay,
      reviews: model.reviews,
      location: VendorModel._fromTopLevelJson(json),
    );
  }

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);

  @JsonKey(name: '_id')
  final String? id;

  final String name;

  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(defaultValue: '')
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

  final HoursModel? hours;
  final String? hoursADay;

  /// ✅ Fixed LatLng parsing: support top-level `lat` and `lng`
  @JsonKey(fromJson: _latLngFromJson, toJson: _latLngToJson)
  final LatLng? location;

  @JsonKey(name: 'menus')
  final List<MenuItemModel>? menu;

  /// 🔥 IMPORTANT:
  /// Search API DOES NOT return reviews
  /// Ignoring prevents runtime crashes
  @JsonKey(ignore: true)
  final ReviewsModel? reviews;

  // ------------------------
  // LatLng Converters
  // ------------------------

  static LatLng? _latLngFromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final lat = json['lat'];
      final lng = json['lng'];
      if (lat != null && lng != null) {
        return LatLng((lat as num).toDouble(), (lng as num).toDouble());
      }
    }
    return null;
  }

  static Map<String, dynamic>? _latLngToJson(LatLng? v) {
    if (v == null) return null;
    return {'lat': v.latitude, 'lng': v.longitude};
  }

  /// Helper to create LatLng from top-level fields
  static LatLng? _fromTopLevelJson(Map<String, dynamic> json) {
    final lat = json['lat'];
    final lng = json['lng'];
    if (lat != null && lng != null) {
      return LatLng((lat as num).toDouble(), (lng as num).toDouble());
    }
    return null;
  }
}

/// ------------------------------------------------
///                MenuItemModel
/// ------------------------------------------------
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

/// ------------------------------------------------
///                ServingModel
/// ------------------------------------------------
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

/// ------------------------------------------------
///                HoursModel
/// ------------------------------------------------
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

/// ------------------------------------------------
///                ReviewsModel
/// ------------------------------------------------
class ReviewsModel {
  final double averageRating;
  final int totalReviews;
  final List<SingleReviewModel> list;

  ReviewsModel({
    required this.averageRating,
    required this.totalReviews,
    required this.list,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      list: (json['reviews'] as List? ?? [])
          .map((e) => SingleReviewModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'reviews': list.map((e) => e.toJson()).toList(),
    };
  }
}

class SingleReviewModel {
  final String id;
  final int rating;
  final String message;
  final DateTime createdAt;
  final ReviewUser user;

  SingleReviewModel({
    required this.id,
    required this.rating,
    required this.message,
    required this.createdAt,
    required this.user,
  });

  factory SingleReviewModel.fromJson(Map<String, dynamic> json) {
    return SingleReviewModel(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      user: ReviewUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rating': rating,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class ReviewUser {
  final String name;
  final String? profileImage;

  ReviewUser({required this.name, this.profileImage});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'profile_image': profileImage};
  }
}
