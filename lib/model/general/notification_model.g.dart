// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['_id'] as String,
      userId: json['user_id'] as String?,
      vendorId: json['vendor_id'] as String?,
      type: json['type'] as String?,
      data: json['data'] == null
          ? null
          : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String?,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      'vendor_id': instance.vendorId,
      'type': instance.type,
      'data': instance.data,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      menuId: json['menuId'] as String?,
      event: json['event'] as String?,
      vendorId: json['vendorId'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'menuId': instance.menuId,
      'event': instance.event,
      'vendorId': instance.vendorId,
      'type': instance.type,
    };
