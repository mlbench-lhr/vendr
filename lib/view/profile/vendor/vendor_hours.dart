import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class VendorHoursScreen extends StatefulWidget {
  const VendorHoursScreen({super.key});

  @override
  State<VendorHoursScreen> createState() => _VendorHoursScreenState();
}

class _VendorHoursScreenState extends State<VendorHoursScreen> {
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
                    HourSelectionSwitch(context: context, day: 'Monday'),
                    HourSelectionSwitch(context: context, day: 'Tuesday'),
                    HourSelectionSwitch(context: context, day: 'Wednesday'),
                    HourSelectionSwitch(context: context, day: 'Thursday'),
                    HourSelectionSwitch(context: context, day: 'Friday'),
                    HourSelectionSwitch(context: context, day: 'Saturday'),
                    HourSelectionSwitch(context: context, day: 'Sunday'),
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
    required this.day,
  });
  final BuildContext context;
  final String day;
  @override
  State<HourSelectionSwitch> createState() => _HourSelectionSwitchState();
}

class _HourSelectionSwitchState extends State<HourSelectionSwitch> {
  bool switchValue = false;

  //pick time
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  Future<void> _pickTime({bool isStartTime = true}) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      if (isStartTime) {
        setState(() {
          _selectedStartTime = time;
        });
      } else {
        setState(() {
          _selectedEndTime = time;
        });
      }
    }
  }

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
                ///
                ///START TIME
                ///
                InkWell(
                  onTap: () {
                    _pickTime(isStartTime: true);
                  },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38, width: 1.5.w),
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white12,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      _selectedStartTime != null
                          ? _selectedStartTime!.format(context)
                          : '00:00',
                      style: context.typography.title.copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),

                ///
                ///END TIME
                ///
                InkWell(
                  onTap: () {
                    _pickTime(isStartTime: false);
                  },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38, width: 1.5.w),
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white12,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      _selectedEndTime != null
                          ? _selectedEndTime!.format(context)
                          : '00:00',
                      style: context.typography.title.copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
