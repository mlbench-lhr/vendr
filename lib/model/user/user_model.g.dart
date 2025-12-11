// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String?,
  name: json['name'] as String,
  imageUrl: json['profile_image'] as String?,
  createdAt: UserModel._fromJsonDateTime(json['createdAt']),
  updatedAt: UserModel._fromJsonDateTime(json['updatedAt']),
  favoriteVendors: (json['favoriteVendors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'profile_image': instance.imageUrl,
  'createdAt': UserModel._toJsonDateTime(instance.createdAt),
  'updatedAt': UserModel._toJsonDateTime(instance.updatedAt),
  'favoriteVendors': instance.favoriteVendors,
};
