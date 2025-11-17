import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';

class VendorMyMenuScreen extends StatefulWidget {
  const VendorMyMenuScreen({super.key});

  @override
  State<VendorMyMenuScreen> createState() => _VendorMyMenuScreenState();
}

class _VendorMyMenuScreenState extends State<VendorMyMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.w), child: Text('My Menu')),
      ),
    );
  }
}
