import 'package:flutter/material.dart';

class ScreenConfig {
  ScreenConfig({
    required this.screen,
    required this.title,
    this.showAppBar = true,
  });
  final Widget screen;
  final String title;
  final bool showAppBar;
}
