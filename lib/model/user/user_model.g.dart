// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  createdAt: UserModel._fromJsonDateTime(json['createdAt']),
  updatedAt: UserModel._fromJsonDateTime(json['updatedAt']),
  favoriteVendors: (json['favoriteVendors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'createdAt': UserModel._toJsonDateTime(instance.createdAt),
  'updatedAt': UserModel._toJsonDateTime(instance.updatedAt),
  'favoriteVendors': instance.favoriteVendors,
};
