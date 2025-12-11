import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: "_id")
  final String id;
  final String title;
  final String body;
  final String image;
  @JsonKey(name: "is_read")
  bool isRead;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.isRead,
    required this.createdAt,
  });

  // From JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
