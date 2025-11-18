import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class VendorHoursScreen extends StatefulWidget {
  const VendorHoursScreen({super.key});

  @override
  State<VendorHoursScreen> createState() => _VendorHoursScreenState();
}

class _VendorHoursScreenState extends State<VendorHoursScreen> {
  List<String> hours = [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Vendor Hours',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Monday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Tuesday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Wednesday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Thursday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Friday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Saturday',
                    ),
                    HourSelectionSwitch(
                      context: context,
                      hours: hours,
                      day: 'Sunday',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Button ALWAYS stays at bottom if space available
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MyButton(label: 'Update', onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HourSelectionSwitch extends StatefulWidget {
  const HourSelectionSwitch({
    super.key,
    required this.context,
    required this.hours,
    required this.day,
  });
  final BuildContext context;
  final List<String> hours;
  final String day;
  @override
  State<HourSelectionSwitch> createState() => _HourSelectionSwitchState();
}

class _HourSelectionSwitchState extends State<HourSelectionSwitch> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.day, style: context.typography.title.copyWith()),
              Switch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    debugPrint('Is ${widget.day} Switched: $switchValue');
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: context.colors.buttonPrimary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white70,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          if (switchValue)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150.w,
                  child: MyDropdown(
                    items: widget.hours,
                    value: widget.hours.first,
                    onChanged: (value) {
                      debugPrint('Start Time updated to: $value');
                    },
                  ),
                ),
                SizedBox(
                  width: 150.w,
                  child: MyDropdown(
                    items: widget.hours,
                    value: widget.hours.first,
                    onChanged: (value) {
                      debugPrint('End Time updated to: $value');
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
