import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    this.id,
    required this.name,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.favoriteVendors,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @JsonKey(name: 'id')
  final String? id;

  final String name;

  final String? imageUrl;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? createdAt;

  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  final DateTime? updatedAt;

  final List<String>? favoriteVendors;

  // -------- DateTime Converters ----------
  static DateTime? _fromJsonDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.parse(value);
    throw ArgumentError('Invalid DateTime format: $value');
  }

  static String? _toJsonDateTime(DateTime? value) =>
      value?.toUtc().toIso8601String();
}
