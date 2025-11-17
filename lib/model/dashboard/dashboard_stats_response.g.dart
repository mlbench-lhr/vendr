// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsResponse _$DashboardStatsResponseFromJson(
  Map<String, dynamic> json,
) => DashboardStatsResponse(
  success: json['success'] as bool,
  data: DashboardStatsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardStatsResponseToJson(
  DashboardStatsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
};

DashboardStatsData _$DashboardStatsDataFromJson(Map<String, dynamic> json) =>
    DashboardStatsData(
      week: StatsPeriod.fromJson(json['week'] as Map<String, dynamic>),
      month: StatsPeriod.fromJson(json['month'] as Map<String, dynamic>),
      year: StatsPeriod.fromJson(json['year'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardStatsDataToJson(DashboardStatsData instance) =>
    <String, dynamic>{
      'week': instance.week.toJson(),
      'month': instance.month.toJson(),
      'year': instance.year.toJson(),
    };

StatsPeriod _$StatsPeriodFromJson(Map<String, dynamic> json) => StatsPeriod(
  profileLikes: ProfileLikes.fromJson(
    json['profileLikes'] as Map<String, dynamic>,
  ),
  bookinglinks: CountOnly.fromJson(
    json['bookinglinks'] as Map<String, dynamic>,
  ),
  consultations: CountOnly.fromJson(
    json['consultations'] as Map<String, dynamic>,
  ),
  earnings: Earnings.fromJson(json['earnings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StatsPeriodToJson(StatsPeriod instance) =>
    <String, dynamic>{
      'profileLikes': instance.profileLikes.toJson(),
      'bookinglinks': instance.bookinglinks.toJson(),
      'consultations': instance.consultations.toJson(),
      'earnings': instance.earnings.toJson(),
    };

ProfileLikes _$ProfileLikesFromJson(Map<String, dynamic> json) => ProfileLikes(
  count: (json['count'] as num).toInt(),
  trend: (json['trend'] as num).toInt(),
);

Map<String, dynamic> _$ProfileLikesToJson(ProfileLikes instance) =>
    <String, dynamic>{'count': instance.count, 'trend': instance.trend};

CountOnly _$CountOnlyFromJson(Map<String, dynamic> json) =>
    CountOnly(count: (json['count'] as num).toInt());

Map<String, dynamic> _$CountOnlyToJson(CountOnly instance) => <String, dynamic>{
  'count': instance.count,
};

Earnings _$EarningsFromJson(Map<String, dynamic> json) =>
    Earnings(amount: (json['amount'] as num).toInt());

Map<String, dynamic> _$EarningsToJson(Earnings instance) => <String, dynamic>{
  'amount': instance.amount,
};
