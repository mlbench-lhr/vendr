import 'package:flutter/foundation.dart';

@immutable
class ChartData {
  const ChartData(this.label, this.value);

  final String label;
  final double value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => Object.hash(label, value);
}
