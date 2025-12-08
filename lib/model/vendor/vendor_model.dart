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
    this.imageUrl,
    this.address,
    this.routes,
    this.location,
    this.menu,
    this.hours,
    this.hoursADay,
    this.provider,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);

  @JsonKey(name: 'id')
  final String? id;

  final String name;
  final String email;
  final String phone;

  @JsonKey(name: 'vendor_type')
  final String vendorType;

  final String? provider;
  final bool? verified;

  // Optional fields
  final String? imageUrl;
  final String? address;

  final List<Map<String, dynamic>>? routes;
  final List<Map<String, dynamic>>? hours;
  final String? hoursADay;

  @JsonKey(fromJson: _latLngFromJson, toJson: _latLngToJson)
  final LatLng? location;

  // Now use properly typed menu items
  final List<MenuItemModel>? menu;

  // -------- LatLng converters ----------
  static LatLng? _latLngFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return LatLng(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    );
  }

  static Map<String, dynamic>? _latLngToJson(LatLng? latLng) {
    if (latLng == null) return null;
    return {'lat': latLng.latitude, 'lng': latLng.longitude};
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
    this.itemImageUrl,
    required this.itemName,
    this.itemDescription,
    required this.servings,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  final String? itemId;
  final String? itemImageUrl;
  final String itemName;
  final String? itemDescription;

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

  final String servingQuantity;
  final String servingPrice;
}
