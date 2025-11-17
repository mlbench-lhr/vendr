import 'package:json_annotation/json_annotation.dart';

part 'medical_opinion_model.g.dart';

@JsonSerializable()
class MedicalOpinion {
  MedicalOpinion({
    this.id,
    this.procedure,
    this.status,
    this.createdAt,
    this.respondedAt,
    this.charges,
    this.userName,
    this.UserName,
    this.userImage,
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorImage,
  });

  factory MedicalOpinion.fromJson(Map<String, dynamic> json) =>
      _$MedicalOpinionFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String? procedure;
  final String? status;
  final DateTime? createdAt;
  final DateTime? respondedAt;
  final num? charges; // handles both int and double

  final String? userName;
  final String? UserName;
  final String? userImage;

  final String? doctorFirstName;
  final String? doctorLastName;
  final String? doctorImage;

  Map<String, dynamic> toJson() => _$MedicalOpinionToJson(this);
}
