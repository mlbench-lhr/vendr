import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// ==============================
/// Notification Model
/// ==============================
@JsonSerializable()
class NotificationModel {
  @JsonKey(name: "_id")
  final String id;

  @JsonKey(name: "user_id")
  final String? userId;

  @JsonKey(name: "vendor_id")
  final String? vendorId;

  /// Top-level notification type (e.g. favorite_vendor)
  final String? type;

  /// Nested payload object
  final NotificationData? data;

  final String title;
  final String body;

  /// Can be null in API response
  final String? image;

  @JsonKey(name: "is_read")
  bool isRead;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.userId,
    this.vendorId,
    this.type,
    this.data,
    required this.title,
    required this.body,
    this.image,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

/// ==============================
/// Notification Data Model
/// ==============================
@JsonSerializable()
class NotificationData {
  final String? menuId;
  final String? event;
  final String? vendorId;
  final String? type;

  NotificationData({this.menuId, this.event, this.vendorId, this.type});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
