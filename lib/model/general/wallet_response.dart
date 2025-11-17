// wallet_response.dart
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_response.g.dart';

@JsonSerializable()
class WalletResponse {
  WalletResponse({
    required this.totalEarnedThisMonth,
    required this.totalPatients,
    required this.totalEarning,
    required this.withdrawable,
    this.commission = 0,
    this.doctorEarningPercentage = 0,
    this.history,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletResponseToJson(this);

  final List<WalletHistory>? history;

  @JsonKey(name: 'totalEarnedThisMonth', defaultValue: 0)
  final int totalEarnedThisMonth;

  @JsonKey(name: 'total_patients', defaultValue: 0)
  final int totalPatients;

  @JsonKey(name: 'total_earning', defaultValue: 0)
  final int totalEarning;

  @JsonKey(defaultValue: 0)
  final int withdrawable;

  @JsonKey(defaultValue: 0)
  final int commission;

  @JsonKey(name: 'doctor_earning_percentage', defaultValue: 0)
  final int doctorEarningPercentage;
}

@JsonSerializable()
class WalletHistory {
  WalletHistory({
    required this.id,
    required this.doctorId,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.userId,
    this.isDeposit = false,
  });

  factory WalletHistory.fromJson(Map<String, dynamic> json) =>
      _$WalletHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$WalletHistoryToJson(this);

  @JsonKey(name: '_id')
  final String id;

  final String doctorId;

  final String? userId;
  @JsonKey(defaultValue: false)
  final bool isDeposit;

  final String type;

  final num amount;

  final String status;

  final DateTime createdAt;

  String get formattedDate {
    return DateFormat('MMM d, yyyy - h:mm a').format(createdAt);
  }
}
