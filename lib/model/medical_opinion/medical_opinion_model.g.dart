// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_opinion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalOpinion _$MedicalOpinionFromJson(Map<String, dynamic> json) =>
    MedicalOpinion(
      id: json['_id'] as String?,
      procedure: json['procedure'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      charges: json['charges'] as num?,
      userName: json['userName'] as String?,
      UserName: json['UserName'] as String?,
      userImage: json['userImage'] as String?,
      doctorFirstName: json['doctorFirstName'] as String?,
      doctorLastName: json['doctorLastName'] as String?,
      doctorImage: json['doctorImage'] as String?,
    );

Map<String, dynamic> _$MedicalOpinionToJson(MedicalOpinion instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'procedure': instance.procedure,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'charges': instance.charges,
      'userName': instance.userName,
      'UserName': instance.UserName,
      'userImage': instance.userImage,
      'doctorFirstName': instance.doctorFirstName,
      'doctorLastName': instance.doctorLastName,
      'doctorImage': instance.doctorImage,
    };
