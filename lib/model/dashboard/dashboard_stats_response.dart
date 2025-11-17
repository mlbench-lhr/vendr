import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardStatsResponse {
  DashboardStatsResponse({
    required this.success,
    required this.data,
  });

  factory DashboardStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsResponseFromJson(json);
  final bool success;
  final DashboardStatsData data;

  Map<String, dynamic> toJson() => _$DashboardStatsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DashboardStatsData {
  DashboardStatsData({
    required this.week,
    required this.month,
    required this.year,
  });

  factory DashboardStatsData.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsDataFromJson(json);
  final StatsPeriod week;
  final StatsPeriod month;
  final StatsPeriod year;

  Map<String, dynamic> toJson() => _$DashboardStatsDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StatsPeriod {
  StatsPeriod({
    required this.profileLikes,
    required this.bookinglinks,
    required this.consultations,
    required this.earnings,
  });

  factory StatsPeriod.fromJson(Map<String, dynamic> json) =>
      _$StatsPeriodFromJson(json);
  final ProfileLikes profileLikes;
  final CountOnly bookinglinks;
  final CountOnly consultations;
  final Earnings earnings;

  Map<String, dynamic> toJson() => _$StatsPeriodToJson(this);
}

@JsonSerializable()
class ProfileLikes {
  ProfileLikes({
    required this.count,
    required this.trend,
  });

  factory ProfileLikes.fromJson(Map<String, dynamic> json) =>
      _$ProfileLikesFromJson(json);
  final int count;
  final int trend;

  Map<String, dynamic> toJson() => _$ProfileLikesToJson(this);
}

@JsonSerializable()
class CountOnly {
  CountOnly({
    required this.count,
  });

  factory CountOnly.fromJson(Map<String, dynamic> json) =>
      _$CountOnlyFromJson(json);
  final int count;

  Map<String, dynamic> toJson() => _$CountOnlyToJson(this);
}

@JsonSerializable()
class Earnings {
  Earnings({
    required this.amount,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) =>
      _$EarningsFromJson(json);
  final int amount;

  Map<String, dynamic> toJson() => _$EarningsToJson(this);
}
