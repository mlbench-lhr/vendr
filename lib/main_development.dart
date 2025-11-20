import 'package:vendr/app/view/app.dart';
import 'package:vendr/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(() => App());
}
