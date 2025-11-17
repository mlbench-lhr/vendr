import 'package:json_annotation/json_annotation.dart';

part 'medical_opinion_details.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicalOpinionDetails {
  MedicalOpinionDetails({
    required this.id,
    required this.procedure,
    required this.note,
    required this.images,
    required this.charges,
    required this.status,
    required this.createdAt,
    this.doctorResponse,
    this.respondedAt,
    this.user,
    this.doctor,
    this.review,
  });

  factory MedicalOpinionDetails.fromJson(Map<String, dynamic> json) =>
      _$MedicalOpinionDetailsFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String procedure;
  final String note;
  final List<String> images;
  final num charges;
  final String status;
  final String? doctorResponse;
  final DateTime? respondedAt;
  final DateTime createdAt;
  final OpinionUser? user;
  final OpinionDoctor? doctor;
  final MedicalOpinionReview? review;

  Map<String, dynamic> toJson() => _$MedicalOpinionDetailsToJson(this);
}

@JsonSerializable()
class OpinionUser {
  OpinionUser({
    required this.id,
    required this.userName,
    this.image,
  });

  factory OpinionUser.fromJson(Map<String, dynamic> json) =>
      _$OpinionUserFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String userName;
  final String? image;

  Map<String, dynamic> toJson() => _$OpinionUserToJson(this);
}

@JsonSerializable()
class OpinionDoctor {
  OpinionDoctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    this.experience,
    this.location,
  });

  factory OpinionDoctor.fromJson(Map<String, dynamic> json) =>
      _$OpinionDoctorFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final String? image;
  final num? experience;
  final String? location;

  Map<String, dynamic> toJson() => _$OpinionDoctorToJson(this);
}

@JsonSerializable()
class MedicalOpinionReview {
  MedicalOpinionReview({
    this.comment,
    this.rating,
  });

  factory MedicalOpinionReview.fromJson(Map<String, dynamic> json) =>
      _$MedicalOpinionReviewFromJson(json);

  final String? comment;
  final num? rating;

  Map<String, dynamic> toJson() => _$MedicalOpinionReviewToJson(this);
}
