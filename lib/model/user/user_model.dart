import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    // required this.firstName,
    // required this.lastName,
    required this.userName,
    required this.email,
    required this.location,
    required this.lat,
    required this.lng,
    this.id,
    this.dob,
    this.image,
    this.gender,
    this.verified,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @JsonKey(name: '_id')
  final String? id;
  // final String firstName;
  // final String lastName;
  final String userName;
  final String email;
  final bool? verified;

  @JsonKey(name: 'dob', fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? dob;

  final String location;
  final String? gender;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? createdAt;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? updatedAt;

  final String? image;
  final double lat;
  final double lng;

  static DateTime? _fromJsonDateTime(dynamic date) {
    if (date == null) return null;
    if (date is String) return DateTime.parse(date);
    throw ArgumentError('Invalid date format');
  }

  static String? _toJsonDateTime(DateTime? date) =>
      date?.toUtc().toIso8601String();
}
