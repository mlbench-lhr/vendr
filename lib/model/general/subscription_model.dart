import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionResponse {
  SubscriptionResponse({
    required this.history,
    this.currentPlan,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  final List<SubscriptionHistory> history;

  @JsonKey(name: 'current_plan')
  final CurrentPlan? currentPlan;

  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
}

@JsonSerializable()
class SubscriptionHistory {
  SubscriptionHistory({
    required this.id,
    required this.doctorId,
    required this.amount,
    required this.clicks,
    required this.createdAt,
    required this.v,
    this.platform,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionHistoryFromJson(json);

  @JsonKey(name: '_id')
  final String id;

  final String doctorId;
  final int amount;
  final int clicks;

  /// Optional platform (e.g., "ios", "apple")
  final String? platform;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: '__v')
  final int v;

  Map<String, dynamic> toJson() => _$SubscriptionHistoryToJson(this);
}

@JsonSerializable()
class CurrentPlan {
  CurrentPlan({
    required this.id,
    required this.doctorId,
    required this.amount,
    required this.cancelAtPeriodEnd,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    required this.status,
    required this.stripePriceId,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedAtAlt,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.platform,
    required this.v,
    this.appleOriginalTransactionId,
    this.appleProductId,
    this.canceledAt,
  });

  factory CurrentPlan.fromJson(Map<String, dynamic> json) =>
      _$CurrentPlanFromJson(json);

  @JsonKey(name: '_id')
  final String id;

  final String doctorId;
  final int amount;

  final String currency;
  final String interval;
  final String platform;

  @JsonKey(name: 'interval_count')
  final int intervalCount;

  final String status;

  @JsonKey(name: 'cancelAtPeriodEnd')
  final bool cancelAtPeriodEnd;

  @JsonKey(name: 'currentPeriodStart')
  final DateTime currentPeriodStart;

  @JsonKey(name: 'currentPeriodEnd')
  final DateTime currentPeriodEnd;

  @JsonKey(name: 'stripePriceId')
  final String stripePriceId;

  /// Optional Apple fields
  final String? appleOriginalTransactionId;
  final String? appleProductId;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAtAlt;

  @JsonKey(name: 'canceledAt')
  final DateTime? canceledAt;

  @JsonKey(name: '__v')
  final int v;

  Map<String, dynamic> toJson() => _$CurrentPlanToJson(this);
}
