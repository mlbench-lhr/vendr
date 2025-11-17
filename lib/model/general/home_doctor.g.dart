// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDoctor _$HomeDoctorFromJson(Map<String, dynamic> json) => HomeDoctor(
  id: json['_id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  specializations: (json['specializations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  clinicName: json['clinicName'] as String,
  location: json['location'] as String,
  isLiked: json['isLiked'] as bool,
  distance: (json['distance'] as num?)?.toDouble(),
  clinicImage: json['clinicImage'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$HomeDoctorToJson(HomeDoctor instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'specializations': instance.specializations,
      'clinicImage': instance.clinicImage,
      'image': instance.image,
      'clinicName': instance.clinicName,
      'location': instance.location,
      'isLiked': instance.isLiked,
      'distance': instance.distance,
    };
