import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    this.id,
    required this.email,
    required this.name,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.favoriteVendors,
    this.newVendorAlert,
    this.distanceBasedAlert,
    this.favoriteVendorAlert,

    //notification settings
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @JsonKey(name: '_id')
  final String? id;

  final String name;

  final String email;

  @JsonKey(name: 'profile_image')
  final String? imageUrl;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? createdAt;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? updatedAt;

  final List<FavoriteVendorModel>? favoriteVendors;

  //notification settings

  @JsonKey(name: 'new_vendor_alert')
  final bool? newVendorAlert;

  @JsonKey(name: 'distance_based_alert')
  final bool? distanceBasedAlert;

  @JsonKey(name: 'favorite_vendor_alert')
  final bool? favoriteVendorAlert;

  // -------- DateTime Converters ----------
  static DateTime? _fromJsonDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.parse(value);
    throw ArgumentError('Invalid DateTime format: $value');
  }

  static String? _toJsonDateTime(DateTime? value) =>
      value?.toUtc().toIso8601String();
}

@JsonSerializable()
class FavoriteVendorModel {
  FavoriteVendorModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.vendorType,
    this.imageUrl,
  });

  factory FavoriteVendorModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteVendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteVendorModelToJson(this);

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String? email;
  final String? phone;

  @JsonKey(name: 'vendor_type')
  final String? vendorType;

  @JsonKey(name: 'profile_image')
  final String? imageUrl;
}
