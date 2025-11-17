// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impression_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImpressionResponse _$ImpressionResponseFromJson(Map<String, dynamic> json) =>
    ImpressionResponse(
      success: json['success'] as bool,
      data: ImpressionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImpressionResponseToJson(ImpressionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };

ImpressionData _$ImpressionDataFromJson(Map<String, dynamic> json) =>
    ImpressionData(
      year: (json['year'] as List<dynamic>)
          .map((e) => ImpressionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      month: (json['month'] as List<dynamic>)
          .map((e) => ImpressionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      week: (json['week'] as List<dynamic>)
          .map((e) => ImpressionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImpressionDataToJson(ImpressionData instance) =>
    <String, dynamic>{
      'year': instance.year.map((e) => e.toJson()).toList(),
      'month': instance.month.map((e) => e.toJson()).toList(),
      'week': instance.week.map((e) => e.toJson()).toList(),
    };

ImpressionItem _$ImpressionItemFromJson(Map<String, dynamic> json) =>
    ImpressionItem(
      count: (json['count'] as num).toInt(),
      beforeAfterPictures: (json['beforeAfterPictures'] as List<dynamic>)
          .map((e) => BeforeAfterPicture.fromJson(e as Map<String, dynamic>))
          .toList(),
      procedureType: json['procedureType'] as String,
    );

Map<String, dynamic> _$ImpressionItemToJson(ImpressionItem instance) =>
    <String, dynamic>{
      'count': instance.count,
      'beforeAfterPictures': instance.beforeAfterPictures
          .map((e) => e.toJson())
          .toList(),
      'procedureType': instance.procedureType,
    };

BeforeAfterPicture _$BeforeAfterPictureFromJson(Map<String, dynamic> json) =>
    BeforeAfterPicture(
      bodyPart: json['bodyPart'] as String,
      beforeImageUrl: json['beforeImageUrl'] as String,
      afterImageUrl: json['afterImageUrl'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$BeforeAfterPictureToJson(BeforeAfterPicture instance) =>
    <String, dynamic>{
      'bodyPart': instance.bodyPart,
      'beforeImageUrl': instance.beforeImageUrl,
      'afterImageUrl': instance.afterImageUrl,
      '_id': instance.id,
    };
