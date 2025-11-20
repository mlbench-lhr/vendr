import 'package:flutter/material.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class PreferncesChip extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChange;

  const PreferncesChip({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.typography.label.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Switch(
          value: value,
          onChanged: onChange,
          activeColor: Colors.white,
          activeTrackColor: Colors.grey,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.white70,
        ),
      ],
    );
  }
}
