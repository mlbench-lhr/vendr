import 'package:json_annotation/json_annotation.dart';

part 'vendor_model.g.dart';

@JsonSerializable()
class VendorModel {
  VendorModel({
    required this.name,
    this.email,
    this.phone,
    required this.vendorType,
    required this.id,
    this.verified,
    this.profileImage,
    this.address,
    this.routes,
    this.menu,
    this.hours,
    this.hoursADay,
    this.totalMenuItems,
    this.provider,
    this.reviews,
    this.lat,
    this.lng,
    this.distanceInKm,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);

  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String? email;
  final String? phone;

  @JsonKey(name: 'vendor_type')
  final String vendorType;

  final String? provider;
  final bool? verified;

  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @JsonKey(name: 'shop_address')
  final String? address;

  final List<Map<String, dynamic>>? routes;

  // NEW FIELDS (replace LatLng)
  final double? lat;
  final double? lng;

  final HoursModel? hours;

  @JsonKey(name: 'todays_hours_count')
  final int? hoursADay;

  @JsonKey(name: 'total_menus')
  final int? totalMenuItems;

  @JsonKey(name: 'menus')
  final List<MenuItemModel>? menu;

  final ReviewsModel? reviews;

  @JsonKey(name: 'distance_in_km')
  final double? distanceInKm;
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

// @JsonSerializable()
// class ServingModel {
//   ServingModel({
//     this.id,
//     required this.servingQuantity,
//     required this.servingPrice,
//   });

//   factory ServingModel.fromJson(Map<String, dynamic> json) =>
//       _$ServingModelFromJson(json);

//   Map<String, dynamic> toJson() => _$ServingModelToJson(this);

//   final int? id;

//   @JsonKey(name: 'serving')
//   final String servingQuantity;

//   @JsonKey(name: 'price')
//   final String servingPrice;
// }

@JsonSerializable()
class ServingModel {
  ServingModel({
    this.id,
    required this.servingQuantity,
    required this.servingPrice,
  });

  factory ServingModel.fromJson(Map<String, dynamic> json) =>
      _$ServingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServingModelToJson(this);

  final int? id;

  @JsonKey(name: 'serving')
  final String servingQuantity;

  @JsonKey(name: 'price')
  final String servingPrice;

  // ----------------------------
  // copyWith for immutable updates
  ServingModel copyWith({
    int? id,
    String? servingQuantity,
    String? servingPrice,
  }) {
    return ServingModel(
      id: id ?? this.id,
      servingQuantity: servingQuantity ?? this.servingQuantity,
      servingPrice: servingPrice ?? this.servingPrice,
    );
  }
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
  final List<SingleReviewModel> list;

  ReviewsModel({
    required this.averageRating,
    required this.totalReviews,
    required this.list,
  });

  // factory ReviewsModel.fromJson(Map<String, dynamic> json) {
  //   return ReviewsModel(
  //     averageRating: (json['average_rating'] ?? 0).toDouble(),
  //     totalReviews: json['total_reviews'] ?? 0,
  //     list: (json['list'] as List? ?? [])
  //         .map((e) => SingleReviewModel.fromJson(e))
  //         .toList(),
  //   );
  // }
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
      'list': list.map((e) => e.toJson()).toList(),
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
