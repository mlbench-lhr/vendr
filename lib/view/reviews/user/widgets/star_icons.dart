import 'package:flutter/material.dart';

class StarIcons extends StatelessWidget {
  final IconData icon;
  final Color color;
  const StarIcons({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: 21);
  }
}
