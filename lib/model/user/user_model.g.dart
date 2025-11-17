// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userName: json['userName'] as String,
  email: json['email'] as String,
  location: json['location'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  id: json['_id'] as String?,
  dob: UserModel._fromJsonDateTime(json['dob']),
  image: json['image'] as String?,
  gender: json['gender'] as String?,
  verified: json['verified'] as bool?,
  createdAt: UserModel._fromJsonDateTime(json['createdAt']),
  updatedAt: UserModel._fromJsonDateTime(json['updatedAt']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'userName': instance.userName,
  'email': instance.email,
  'verified': instance.verified,
  'dob': UserModel._toJsonDateTime(instance.dob),
  'location': instance.location,
  'gender': instance.gender,
  'createdAt': UserModel._toJsonDateTime(instance.createdAt),
  'updatedAt': UserModel._toJsonDateTime(instance.updatedAt),
  'image': instance.image,
  'lat': instance.lat,
  'lng': instance.lng,
};
