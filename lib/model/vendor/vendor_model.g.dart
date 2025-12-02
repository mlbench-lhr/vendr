// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) => VendorModel(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  vendorType: json['vendor_type'] as String,
  id: json['id'] as String?,
  verified: json['verified'] as bool?,
  imageUrl: json['imageUrl'] as String?,
  address: json['address'] as String?,
  routes: (json['routes'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  location: VendorModel._latLngFromJson(
    json['location'] as Map<String, dynamic>?,
  ),
  menu: (json['menu'] as List<dynamic>?)
      ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  hours: (json['hours'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  hoursADay: json['hoursADay'] as String?,
  provider: json['provider'] as String?,
);

Map<String, dynamic> _$VendorModelToJson(VendorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'vendor_type': instance.vendorType,
      'provider': instance.provider,
      'verified': instance.verified,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'routes': instance.routes,
      'hours': instance.hours,
      'hoursADay': instance.hoursADay,
      'location': VendorModel._latLngToJson(instance.location),
      'menu': instance.menu,
    };

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      itemId: json['itemId'] as String?,
      itemImageUrl: json['itemImageUrl'] as String?,
      itemName: json['itemName'] as String,
      itemDescription: json['itemDescription'] as String?,
      servings: (json['servings'] as List<dynamic>)
          .map((e) => ServingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemImageUrl': instance.itemImageUrl,
      'itemName': instance.itemName,
      'itemDescription': instance.itemDescription,
      'servings': instance.servings,
    };

ServingModel _$ServingModelFromJson(Map<String, dynamic> json) => ServingModel(
  servingQuantity: json['servingQuantity'] as String,
  servingPrice: json['servingPrice'] as String,
);

Map<String, dynamic> _$ServingModelToJson(ServingModel instance) =>
    <String, dynamic>{
      'servingQuantity': instance.servingQuantity,
      'servingPrice': instance.servingPrice,
    };
