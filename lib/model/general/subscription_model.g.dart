// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionResponse _$SubscriptionResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionResponse(
  history: (json['history'] as List<dynamic>)
      .map((e) => SubscriptionHistory.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentPlan: json['current_plan'] == null
      ? null
      : CurrentPlan.fromJson(json['current_plan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubscriptionResponseToJson(
  SubscriptionResponse instance,
) => <String, dynamic>{
  'history': instance.history,
  'current_plan': instance.currentPlan,
};

SubscriptionHistory _$SubscriptionHistoryFromJson(Map<String, dynamic> json) =>
    SubscriptionHistory(
      id: json['_id'] as String,
      doctorId: json['doctorId'] as String,
      amount: (json['amount'] as num).toInt(),
      clicks: (json['clicks'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      v: (json['__v'] as num).toInt(),
      platform: json['platform'] as String?,
    );

Map<String, dynamic> _$SubscriptionHistoryToJson(
  SubscriptionHistory instance,
) => <String, dynamic>{
  '_id': instance.id,
  'doctorId': instance.doctorId,
  'amount': instance.amount,
  'clicks': instance.clicks,
  'platform': instance.platform,
  'createdAt': instance.createdAt.toIso8601String(),
  '__v': instance.v,
};

CurrentPlan _$CurrentPlanFromJson(Map<String, dynamic> json) => CurrentPlan(
  id: json['_id'] as String,
  doctorId: json['doctorId'] as String,
  amount: (json['amount'] as num).toInt(),
  cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool,
  currency: json['currency'] as String,
  interval: json['interval'] as String,
  intervalCount: (json['interval_count'] as num).toInt(),
  status: json['status'] as String,
  stripePriceId: json['stripePriceId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedAtAlt: DateTime.parse(json['updated_at'] as String),
  currentPeriodStart: DateTime.parse(json['currentPeriodStart'] as String),
  currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] as String),
  platform: json['platform'] as String,
  v: (json['__v'] as num).toInt(),
  appleOriginalTransactionId: json['appleOriginalTransactionId'] as String?,
  appleProductId: json['appleProductId'] as String?,
  canceledAt: json['canceledAt'] == null
      ? null
      : DateTime.parse(json['canceledAt'] as String),
);

Map<String, dynamic> _$CurrentPlanToJson(CurrentPlan instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'doctorId': instance.doctorId,
      'amount': instance.amount,
      'currency': instance.currency,
      'interval': instance.interval,
      'platform': instance.platform,
      'interval_count': instance.intervalCount,
      'status': instance.status,
      'cancelAtPeriodEnd': instance.cancelAtPeriodEnd,
      'currentPeriodStart': instance.currentPeriodStart.toIso8601String(),
      'currentPeriodEnd': instance.currentPeriodEnd.toIso8601String(),
      'stripePriceId': instance.stripePriceId,
      'appleOriginalTransactionId': instance.appleOriginalTransactionId,
      'appleProductId': instance.appleProductId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updated_at': instance.updatedAtAlt.toIso8601String(),
      'canceledAt': instance.canceledAt?.toIso8601String(),
      '__v': instance.v,
    };
