import 'package:json_annotation/json_annotation.dart';

part 'impression_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ImpressionResponse {

  ImpressionResponse({
    required this.success,
    required this.data,
  });

  factory ImpressionResponse.fromJson(Map<String, dynamic> json) =>
      _$ImpressionResponseFromJson(json);
  final bool success;
  final ImpressionData data;

  Map<String, dynamic> toJson() => _$ImpressionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpressionData {

  ImpressionData({
    required this.year,
    required this.month,
    required this.week,
  });

  factory ImpressionData.fromJson(Map<String, dynamic> json) =>
      _$ImpressionDataFromJson(json);
  final List<ImpressionItem> year;
  final List<ImpressionItem> month;
  final List<ImpressionItem> week;

  Map<String, dynamic> toJson() => _$ImpressionDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpressionItem {

  ImpressionItem({
    required this.count,
    required this.beforeAfterPictures,
    required this.procedureType,
  });

  factory ImpressionItem.fromJson(Map<String, dynamic> json) =>
      _$ImpressionItemFromJson(json);
  final int count;
  final List<BeforeAfterPicture> beforeAfterPictures;
  final String procedureType;

  Map<String, dynamic> toJson() => _$ImpressionItemToJson(this);
}

@JsonSerializable()
class BeforeAfterPicture {

  BeforeAfterPicture({
    required this.bodyPart,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.id,
  });

  factory BeforeAfterPicture.fromJson(Map<String, dynamic> json) =>
      _$BeforeAfterPictureFromJson(json);
  final String bodyPart;
  final String beforeImageUrl;
  final String afterImageUrl;
  @JsonKey(name: '_id')
  final String id;

  Map<String, dynamic> toJson() => _$BeforeAfterPictureToJson(this);
}
