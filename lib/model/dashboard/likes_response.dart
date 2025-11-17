import 'package:vendr/model/dashboard/chart_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'likes_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LikesResponse {
  LikesResponse({required this.success, required this.data});

  factory LikesResponse.fromJson(Map<String, dynamic> json) =>
      _$LikesResponseFromJson(json);

  final bool success;
  final LikesData data;

  Map<String, dynamic> toJson() => _$LikesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LikesData {
  LikesData({required this.week, required this.month, required this.year});

  factory LikesData.fromJson(Map<String, dynamic> json) =>
      _$LikesDataFromJson(json);

  final List<WeekLikes> week;
  final List<MonthLikes> month;
  final List<YearLikes> year;

  Map<String, dynamic> toJson() => _$LikesDataToJson(this);

  /// Normalize into [ChartData]
  List<ChartData> get weekChart => week.map((e) => e.toChartData()).toList();

  List<ChartData> get monthChart => month.map((e) => e.toChartData()).toList();

  List<ChartData> get yearChart => year.map((e) => e.toChartData()).toList();
}

@JsonSerializable()
class WeekLikes {
  WeekLikes({required this.day, required this.likes});

  factory WeekLikes.fromJson(Map<String, dynamic> json) =>
      _$WeekLikesFromJson(json);

  final String day;
  final int likes;

  Map<String, dynamic> toJson() => _$WeekLikesToJson(this);

  ChartData toChartData() => ChartData(day, likes.toDouble());
}

@JsonSerializable()
class MonthLikes {
  MonthLikes({required this.week, required this.likes});

  factory MonthLikes.fromJson(Map<String, dynamic> json) =>
      _$MonthLikesFromJson(json);

  final String week;
  final int likes;

  Map<String, dynamic> toJson() => _$MonthLikesToJson(this);

  ChartData toChartData() => ChartData(week, likes.toDouble());
}

@JsonSerializable()
class YearLikes {
  YearLikes({required this.month, required this.likes});

  factory YearLikes.fromJson(Map<String, dynamic> json) =>
      _$YearLikesFromJson(json);

  final String month;
  final int likes;

  Map<String, dynamic> toJson() => _$YearLikesToJson(this);

  ChartData toChartData() => ChartData(month, likes.toDouble());
}
