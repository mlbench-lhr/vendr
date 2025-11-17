import 'package:vendr/model/dashboard/chart_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'earnings_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EarningsResponse {
  EarningsResponse({required this.success, required this.data});

  factory EarningsResponse.fromJson(Map<String, dynamic> json) =>
      _$EarningsResponseFromJson(json);

  final bool success;
  final EarningsData data;

  Map<String, dynamic> toJson() => _$EarningsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EarningsData {
  EarningsData({required this.week, required this.month, required this.year});

  factory EarningsData.fromJson(Map<String, dynamic> json) =>
      _$EarningsDataFromJson(json);

  final List<WeekEarning> week;
  final List<MonthEarning> month;
  final List<YearEarning> year;

  Map<String, dynamic> toJson() => _$EarningsDataToJson(this);

  /// Helpers to normalize into [ChartData]
  List<ChartData> get weekChart => week.map((e) => e.toChartData()).toList();

  List<ChartData> get monthChart => month.map((e) => e.toChartData()).toList();

  List<ChartData> get yearChart => year.map((e) => e.toChartData()).toList();
}

@JsonSerializable()
class WeekEarning {
  WeekEarning({required this.day, required this.earnings});

  factory WeekEarning.fromJson(Map<String, dynamic> json) =>
      _$WeekEarningFromJson(json);

  final String day;
  final double earnings;

  Map<String, dynamic> toJson() => _$WeekEarningToJson(this);

  ChartData toChartData() => ChartData(day, earnings);
}

@JsonSerializable()
class MonthEarning {
  MonthEarning({required this.week, required this.earnings});

  factory MonthEarning.fromJson(Map<String, dynamic> json) =>
      _$MonthEarningFromJson(json);

  final String week;
  final double earnings;

  Map<String, dynamic> toJson() => _$MonthEarningToJson(this);

  ChartData toChartData() => ChartData(week, earnings);
}

@JsonSerializable()
class YearEarning {
  YearEarning({required this.month, required this.earnings});

  factory YearEarning.fromJson(Map<String, dynamic> json) =>
      _$YearEarningFromJson(json);

  final String month;
  final double earnings;

  Map<String, dynamic> toJson() => _$YearEarningToJson(this);

  ChartData toChartData() => ChartData(month, earnings);
}
