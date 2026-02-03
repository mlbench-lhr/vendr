// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String?,
  email: json['email'] as String,
  name: json['name'] as String,
  imageUrl: json['profile_image'] as String?,
  createdAt: UserModel._fromJsonDateTime(json['createdAt']),
  updatedAt: UserModel._fromJsonDateTime(json['updatedAt']),
  favoriteVendors: (json['favoriteVendors'] as List<dynamic>?)
      ?.map((e) => FavoriteVendorModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  newVendorAlert: json['new_vendor_alert'] as bool?,
  distanceBasedAlert: json['distance_based_alert'] as bool?,
  favoriteVendorAlert: json['favorite_vendor_alert'] as bool?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  requestsRemaining: (json['requests_remaining'] as num?)?.toInt(),
  requestsLastResetAt: UserModel._fromJsonDateTime(
    json['requests_last_reset_at'],
  ),
  language: json['language'] as String?,
  averageRating: (json['average_rating'] as num?)?.toDouble(),
  totalReviews: (json['total_reviews'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'profile_image': instance.imageUrl,
  'createdAt': UserModel._toJsonDateTime(instance.createdAt),
  'updatedAt': UserModel._toJsonDateTime(instance.updatedAt),
  'favoriteVendors': instance.favoriteVendors,
  'new_vendor_alert': instance.newVendorAlert,
  'distance_based_alert': instance.distanceBasedAlert,
  'favorite_vendor_alert': instance.favoriteVendorAlert,
  'lat': instance.lat,
  'lng': instance.lng,
  'requests_remaining': instance.requestsRemaining,
  'requests_last_reset_at': UserModel._toJsonDateTime(
    instance.requestsLastResetAt,
  ),
  'language': instance.language,
  'average_rating': instance.averageRating,
  'total_reviews': instance.totalReviews,
};

FavoriteVendorModel _$FavoriteVendorModelFromJson(Map<String, dynamic> json) =>
    FavoriteVendorModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      vendorType: json['vendor_type'] as String?,
      imageUrl: json['profile_image'] as String?,
    );

Map<String, dynamic> _$FavoriteVendorModelToJson(
  FavoriteVendorModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'vendor_type': instance.vendorType,
  'profile_image': instance.imageUrl,
};
