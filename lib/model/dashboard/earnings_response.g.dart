// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarningsResponse _$EarningsResponseFromJson(Map<String, dynamic> json) =>
    EarningsResponse(
      success: json['success'] as bool,
      data: EarningsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EarningsResponseToJson(EarningsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };

EarningsData _$EarningsDataFromJson(Map<String, dynamic> json) => EarningsData(
  week: (json['week'] as List<dynamic>)
      .map((e) => WeekEarning.fromJson(e as Map<String, dynamic>))
      .toList(),
  month: (json['month'] as List<dynamic>)
      .map((e) => MonthEarning.fromJson(e as Map<String, dynamic>))
      .toList(),
  year: (json['year'] as List<dynamic>)
      .map((e) => YearEarning.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EarningsDataToJson(EarningsData instance) =>
    <String, dynamic>{
      'week': instance.week.map((e) => e.toJson()).toList(),
      'month': instance.month.map((e) => e.toJson()).toList(),
      'year': instance.year.map((e) => e.toJson()).toList(),
    };

WeekEarning _$WeekEarningFromJson(Map<String, dynamic> json) => WeekEarning(
  day: json['day'] as String,
  earnings: (json['earnings'] as num).toDouble(),
);

Map<String, dynamic> _$WeekEarningToJson(WeekEarning instance) =>
    <String, dynamic>{'day': instance.day, 'earnings': instance.earnings};

MonthEarning _$MonthEarningFromJson(Map<String, dynamic> json) => MonthEarning(
  week: json['week'] as String,
  earnings: (json['earnings'] as num).toDouble(),
);

Map<String, dynamic> _$MonthEarningToJson(MonthEarning instance) =>
    <String, dynamic>{'week': instance.week, 'earnings': instance.earnings};

YearEarning _$YearEarningFromJson(Map<String, dynamic> json) => YearEarning(
  month: json['month'] as String,
  earnings: (json['earnings'] as num).toDouble(),
);

Map<String, dynamic> _$YearEarningToJson(YearEarning instance) =>
    <String, dynamic>{'month': instance.month, 'earnings': instance.earnings};
