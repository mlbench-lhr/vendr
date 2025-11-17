// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_opinion_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalOpinionDetails _$MedicalOpinionDetailsFromJson(
  Map<String, dynamic> json,
) => MedicalOpinionDetails(
  id: json['_id'] as String,
  procedure: json['procedure'] as String,
  note: json['note'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  charges: json['charges'] as num,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  doctorResponse: json['doctorResponse'] as String?,
  respondedAt: json['respondedAt'] == null
      ? null
      : DateTime.parse(json['respondedAt'] as String),
  user: json['user'] == null
      ? null
      : OpinionUser.fromJson(json['user'] as Map<String, dynamic>),
  doctor: json['doctor'] == null
      ? null
      : OpinionDoctor.fromJson(json['doctor'] as Map<String, dynamic>),
  review: json['review'] == null
      ? null
      : MedicalOpinionReview.fromJson(json['review'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MedicalOpinionDetailsToJson(
  MedicalOpinionDetails instance,
) => <String, dynamic>{
  '_id': instance.id,
  'procedure': instance.procedure,
  'note': instance.note,
  'images': instance.images,
  'charges': instance.charges,
  'status': instance.status,
  'doctorResponse': instance.doctorResponse,
  'respondedAt': instance.respondedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'user': instance.user?.toJson(),
  'doctor': instance.doctor?.toJson(),
  'review': instance.review?.toJson(),
};

OpinionUser _$OpinionUserFromJson(Map<String, dynamic> json) => OpinionUser(
  id: json['_id'] as String,
  userName: json['userName'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$OpinionUserToJson(OpinionUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userName': instance.userName,
      'image': instance.image,
    };

OpinionDoctor _$OpinionDoctorFromJson(Map<String, dynamic> json) =>
    OpinionDoctor(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String?,
      experience: json['experience'] as num?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$OpinionDoctorToJson(OpinionDoctor instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'experience': instance.experience,
      'location': instance.location,
    };

MedicalOpinionReview _$MedicalOpinionReviewFromJson(
  Map<String, dynamic> json,
) => MedicalOpinionReview(
  comment: json['comment'] as String?,
  rating: json['rating'] as num?,
);

Map<String, dynamic> _$MedicalOpinionReviewToJson(
  MedicalOpinionReview instance,
) => <String, dynamic>{'comment': instance.comment, 'rating': instance.rating};
