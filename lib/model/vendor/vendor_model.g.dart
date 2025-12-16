// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) => VendorModel(
  id: json['_id'] as String?,
  name: json['name'] as String,
  vendorType: json['vendor_type'] as String,
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  provider: json['provider'] as String?,
  verified: json['verified'] as bool?,
  profileImage: json['profile_image'] as String?,
  address: json['shop_address'] as String?,
  routes: (json['routes'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  location: VendorModel._latLngFromJson(json['location']),
  menu: (json['menus'] as List<dynamic>?)
      ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  hours: json['hours'] == null
      ? null
      : HoursModel.fromJson(json['hours'] as Map<String, dynamic>),
  hoursADay: json['hoursADay'] as String?,
);

Map<String, dynamic> _$VendorModelToJson(VendorModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'vendor_type': instance.vendorType,
      'provider': instance.provider,
      'verified': instance.verified,
      'profile_image': instance.profileImage,
      'shop_address': instance.address,
      'routes': instance.routes,
      'hours': instance.hours,
      'hoursADay': instance.hoursADay,
      'location': VendorModel._latLngToJson(instance.location),
      'menus': instance.menu,
    };

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      itemId: json['_id'] as String?,
      itemName: json['name'] as String,
      itemDescription: json['description'] as String?,
      servings: (json['servings'] as List<dynamic>)
          .map((e) => ServingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      '_id': instance.itemId,
      'name': instance.itemName,
      'description': instance.itemDescription,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'servings': instance.servings,
    };

ServingModel _$ServingModelFromJson(Map<String, dynamic> json) => ServingModel(
  servingQuantity: json['serving'] as String,
  servingPrice: json['price'] as String,
);

Map<String, dynamic> _$ServingModelToJson(ServingModel instance) =>
    <String, dynamic>{
      'serving': instance.servingQuantity,
      'price': instance.servingPrice,
    };

HoursModel _$HoursModelFromJson(Map<String, dynamic> json) =>
    HoursModel(days: Days.fromJson(json['days'] as Map<String, dynamic>));

Map<String, dynamic> _$HoursModelToJson(HoursModel instance) =>
    <String, dynamic>{'days': instance.days};

Days _$DaysFromJson(Map<String, dynamic> json) => Days(
  monday: DayHours.fromJson(json['monday'] as Map<String, dynamic>),
  tuesday: DayHours.fromJson(json['tuesday'] as Map<String, dynamic>),
  wednesday: DayHours.fromJson(json['wednesday'] as Map<String, dynamic>),
  thursday: DayHours.fromJson(json['thursday'] as Map<String, dynamic>),
  friday: DayHours.fromJson(json['friday'] as Map<String, dynamic>),
  saturday: DayHours.fromJson(json['saturday'] as Map<String, dynamic>),
  sunday: DayHours.fromJson(json['sunday'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DaysToJson(Days instance) => <String, dynamic>{
  'monday': instance.monday,
  'tuesday': instance.tuesday,
  'wednesday': instance.wednesday,
  'thursday': instance.thursday,
  'friday': instance.friday,
  'saturday': instance.saturday,
  'sunday': instance.sunday,
};

DayHours _$DayHoursFromJson(Map<String, dynamic> json) => DayHours(
  enabled: json['enabled'] as bool,
  start: json['start'] as String,
  end: json['end'] as String,
);

Map<String, dynamic> _$DayHoursToJson(DayHours instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'start': instance.start,
  'end': instance.end,
};
