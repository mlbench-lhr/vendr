// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    WalletResponse(
      totalEarnedThisMonth:
          (json['totalEarnedThisMonth'] as num?)?.toInt() ?? 0,
      totalPatients: (json['total_patients'] as num?)?.toInt() ?? 0,
      totalEarning: (json['total_earning'] as num?)?.toInt() ?? 0,
      withdrawable: (json['withdrawable'] as num?)?.toInt() ?? 0,
      commission: (json['commission'] as num?)?.toInt() ?? 0,
      doctorEarningPercentage:
          (json['doctor_earning_percentage'] as num?)?.toInt() ?? 0,
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => WalletHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletResponseToJson(WalletResponse instance) =>
    <String, dynamic>{
      'history': instance.history,
      'totalEarnedThisMonth': instance.totalEarnedThisMonth,
      'total_patients': instance.totalPatients,
      'total_earning': instance.totalEarning,
      'withdrawable': instance.withdrawable,
      'commission': instance.commission,
      'doctor_earning_percentage': instance.doctorEarningPercentage,
    };

WalletHistory _$WalletHistoryFromJson(Map<String, dynamic> json) =>
    WalletHistory(
      id: json['_id'] as String,
      doctorId: json['doctorId'] as String,
      type: json['type'] as String,
      amount: json['amount'] as num,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String?,
      isDeposit: json['isDeposit'] as bool? ?? false,
    );

Map<String, dynamic> _$WalletHistoryToJson(WalletHistory instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'doctorId': instance.doctorId,
      'userId': instance.userId,
      'isDeposit': instance.isDeposit,
      'type': instance.type,
      'amount': instance.amount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
