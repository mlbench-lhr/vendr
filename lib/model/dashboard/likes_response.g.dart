// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikesResponse _$LikesResponseFromJson(Map<String, dynamic> json) =>
    LikesResponse(
      success: json['success'] as bool,
      data: LikesData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikesResponseToJson(LikesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };

LikesData _$LikesDataFromJson(Map<String, dynamic> json) => LikesData(
  week: (json['week'] as List<dynamic>)
      .map((e) => WeekLikes.fromJson(e as Map<String, dynamic>))
      .toList(),
  month: (json['month'] as List<dynamic>)
      .map((e) => MonthLikes.fromJson(e as Map<String, dynamic>))
      .toList(),
  year: (json['year'] as List<dynamic>)
      .map((e) => YearLikes.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LikesDataToJson(LikesData instance) => <String, dynamic>{
  'week': instance.week.map((e) => e.toJson()).toList(),
  'month': instance.month.map((e) => e.toJson()).toList(),
  'year': instance.year.map((e) => e.toJson()).toList(),
};

WeekLikes _$WeekLikesFromJson(Map<String, dynamic> json) => WeekLikes(
  day: json['day'] as String,
  likes: (json['likes'] as num).toInt(),
);

Map<String, dynamic> _$WeekLikesToJson(WeekLikes instance) => <String, dynamic>{
  'day': instance.day,
  'likes': instance.likes,
};

MonthLikes _$MonthLikesFromJson(Map<String, dynamic> json) => MonthLikes(
  week: json['week'] as String,
  likes: (json['likes'] as num).toInt(),
);

Map<String, dynamic> _$MonthLikesToJson(MonthLikes instance) =>
    <String, dynamic>{'week': instance.week, 'likes': instance.likes};

YearLikes _$YearLikesFromJson(Map<String, dynamic> json) => YearLikes(
  month: json['month'] as String,
  likes: (json['likes'] as num).toInt(),
);

Map<String, dynamic> _$YearLikesToJson(YearLikes instance) => <String, dynamic>{
  'month': instance.month,
  'likes': instance.likes,
};
