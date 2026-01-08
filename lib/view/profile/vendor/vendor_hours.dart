import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';

class VendorHoursScreen extends StatefulWidget {
  const VendorHoursScreen({super.key});

  @override
  State<VendorHoursScreen> createState() => _VendorHoursScreenState();
}

class _VendorHoursScreenState extends State<VendorHoursScreen> {
  final _vendorProfileService = VendorProfileService();
  bool isLoading = false;

  //Monday
  bool _isMondayEnabled = false;
  String _mondayStartTime = '00:00';
  String _mondayEndTime = '00:00';
  //Tuesday
  bool _isTuesdayEnabled = false;
  String _tuesdayStartTime = '00:00';
  String _tuesdayEndTime = '00:00';
  //Wednesday
  bool _isWednesdayEnabled = false;
  String _wednesdayStartTime = '00:00';
  String _wednesdayEndTime = '00:00';
  //Thursday
  bool _isThursdayEnabled = false;
  String _thursdayStartTime = '00:00';
  String _thursdayEndTime = '00:00';
  //Friday
  bool _isFridayEnabled = false;
  String _fridayStartTime = '00:00';
  String _fridayEndTime = '00:00';
  //Saturday
  bool _isSaturdayEnabled = false;
  String _saturdayStartTime = '00:00';
  String _saturdayEndTime = '00:00';
  //Sunday
  bool _isSundayEnabled = false;
  String _sundayStartTime = '00:00';
  String _sundayEndTime = '00:00';

  @override
  void initState() {
    setDataFromSession();
    super.initState();
  }

  final _sessionController = SessionController();
  void setDataFromSession() {
    final vendor = _sessionController.vendor!;

    if (vendor.hours?.days == null) {
      return;
    }
    final days = vendor.hours!.days;
    //Monday
    _isMondayEnabled = days.monday.enabled;
    _mondayStartTime = days.monday.start;
    _mondayEndTime = days.monday.end;
    //Tuesday
    _isTuesdayEnabled = days.tuesday.enabled;
    _tuesdayStartTime = days.tuesday.start;
    _tuesdayEndTime = days.tuesday.end;
    //Wednesday
    _isWednesdayEnabled = days.wednesday.enabled;
    _wednesdayStartTime = days.wednesday.start;
    _wednesdayEndTime = days.wednesday.end;
    //Thursday
    _isThursdayEnabled = days.thursday.enabled;
    _thursdayStartTime = days.thursday.start;
    _thursdayEndTime = days.thursday.end;
    //Friday
    _isFridayEnabled = days.friday.enabled;
    _fridayStartTime = days.friday.start;
    _fridayEndTime = days.friday.end;
    //Saturday
    _isSaturdayEnabled = days.saturday.enabled;
    _saturdayStartTime = days.saturday.start;
    _saturdayEndTime = days.saturday.end;
    //Sunday
    _isSundayEnabled = days.sunday.enabled;
    _sundayStartTime = days.sunday.start;
    _sundayEndTime = days.sunday.end;
  }

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
                      day: 'Monday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _mondayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _mondayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isMondayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isMondayEnabled,
                      defaultStartTime: _mondayStartTime,
                      defaultEndTime: _mondayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Tuesday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _tuesdayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _tuesdayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isTuesdayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isTuesdayEnabled,
                      defaultStartTime: _tuesdayStartTime,
                      defaultEndTime: _tuesdayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Wednesday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _wednesdayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _wednesdayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isWednesdayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isWednesdayEnabled,
                      defaultStartTime: _wednesdayStartTime,
                      defaultEndTime: _wednesdayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Thursday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _thursdayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _thursdayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isThursdayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isThursdayEnabled,
                      defaultStartTime: _thursdayStartTime,
                      defaultEndTime: _thursdayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Friday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _fridayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _fridayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isFridayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isFridayEnabled,
                      defaultStartTime: _fridayStartTime,
                      defaultEndTime: _fridayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Saturday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _saturdayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _saturdayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isSaturdayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isSaturdayEnabled,
                      defaultStartTime: _saturdayStartTime,
                      defaultEndTime: _saturdayEndTime,
                    ),
                    HourSelectionSwitch(
                      context: context,
                      day: 'Sunday',
                      onTimeChanged: (Map<String, dynamic> value) {
                        setState(() {
                          if (value['isStartTime']) {
                            setState(() {
                              _sundayStartTime = value['time'];
                            });
                          } else {
                            setState(() {
                              _sundayEndTime = value['time'];
                            });
                          }
                        });
                      },
                      onStatusChanged: (bool value) {
                        setState(() {
                          _isSundayEnabled = value;
                        });
                      },
                      defaultSwitchValue: _isSundayEnabled,
                      defaultStartTime: _sundayStartTime,
                      defaultEndTime: _sundayEndTime,
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
                child: MyButton(
                  label: 'Update',
                  isLoading: isLoading,
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      "days": {
                        "monday": {
                          "enabled": _isMondayEnabled,
                          "start": _mondayStartTime,
                          "end": _mondayEndTime,
                        },
                        "tuesday": {
                          "enabled": _isTuesdayEnabled,
                          "start": _tuesdayStartTime,
                          "end": _tuesdayEndTime,
                        },
                        "wednesday": {
                          "enabled": _isWednesdayEnabled,
                          "start": _wednesdayStartTime,
                          "end": _wednesdayEndTime,
                        },
                        "thursday": {
                          "enabled": _isThursdayEnabled,
                          "start": _thursdayStartTime,
                          "end": _thursdayEndTime,
                        },
                        "friday": {
                          "enabled": _isFridayEnabled,
                          "start": _fridayStartTime,
                          "end": _fridayEndTime,
                        },
                        "saturday": {
                          "enabled": _isSaturdayEnabled,
                          "start": _saturdayStartTime,
                          "end": _saturdayEndTime,
                        },
                        "sunday": {
                          "enabled": _isSundayEnabled,
                          "start": _sundayStartTime,
                          "end": _sundayEndTime,
                        },
                      },
                    };
                    debugPrint('Data: $data');

                    //Validation
                    // Validate all enabled days
                    final checks = [
                      (
                        "Monday",
                        _isMondayEnabled,
                        _mondayStartTime,
                        _mondayEndTime,
                      ),
                      (
                        "Tuesday",
                        _isTuesdayEnabled,
                        _tuesdayStartTime,
                        _tuesdayEndTime,
                      ),
                      (
                        "Wednesday",
                        _isWednesdayEnabled,
                        _wednesdayStartTime,
                        _wednesdayEndTime,
                      ),
                      (
                        "Thursday",
                        _isThursdayEnabled,
                        _thursdayStartTime,
                        _thursdayEndTime,
                      ),
                      (
                        "Friday",
                        _isFridayEnabled,
                        _fridayStartTime,
                        _fridayEndTime,
                      ),
                      (
                        "Saturday",
                        _isSaturdayEnabled,
                        _saturdayStartTime,
                        _saturdayEndTime,
                      ),
                      (
                        "Sunday",
                        _isSundayEnabled,
                        _sundayStartTime,
                        _sundayEndTime,
                      ),
                    ];
                    for (final day in checks) {
                      final dayName = day.$1;
                      final enabled = day.$2;
                      final start = day.$3;
                      final end = day.$4;

                      if (enabled && _isEndBeforeStart(start, end)) {
                        context.flushBarErrorMessage(
                          message:
                              'Invalid hours for $dayName: End time cannot be before start time.',
                        );
                        return;
                      }
                    }
                    //END: Validation
                    setState(() {
                      isLoading = true;
                    });
                    await _vendorProfileService.updateVendorHours(
                      context,
                      data,
                      () {
                        context.flushBarSuccessMessage(
                          message: 'Vendor hours updated successfully!',
                        );
                      },
                    );
                    if (mounted) {
                      setState(() => isLoading = false);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isEndBeforeStart(String start, String end) {
    final s = start.split(':');
    final e = end.split(':');

    final startMinutes = int.parse(s[0]) * 60 + int.parse(s[1]);
    final endMinutes = int.parse(e[0]) * 60 + int.parse(e[1]);

    return endMinutes < startMinutes;
  }
}

class HourSelectionSwitch extends StatefulWidget {
  const HourSelectionSwitch({
    super.key,
    required this.context,
    required this.day,
    required this.onTimeChanged,
    required this.onStatusChanged,
    required this.defaultSwitchValue,
    required this.defaultStartTime,
    required this.defaultEndTime,
  });

  final BuildContext context;
  final String day;
  final bool defaultSwitchValue;
  final String defaultStartTime;
  final String defaultEndTime;

  //callbacks
  final ValueChanged<Map<String, dynamic>> onTimeChanged;
  final ValueChanged<bool> onStatusChanged;
  @override
  State<HourSelectionSwitch> createState() => _HourSelectionSwitchState();
}

class _HourSelectionSwitchState extends State<HourSelectionSwitch> {
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
      //extract time string
      String formattedTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      //notify time
      widget.onTimeChanged({'isStartTime': isStartTime, 'time': formattedTime});

      debugPrint('time : $formattedTime');
    }
  }

  @override
  void initState() {
    setTimeFromSession();
    super.initState();
  }

  void setTimeFromSession() {
    setState(() {
      _selectedStartTime = stringToTimeOfDay(widget.defaultStartTime);
      _selectedEndTime = stringToTimeOfDay(widget.defaultEndTime);
    });
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    //here
    final parts = timeString.split(":");
    TimeOfDay time = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    return time;
  }

  @override
  Widget build(BuildContext context) {
    bool switchValue = widget.defaultSwitchValue;
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
                    widget.onStatusChanged(value);
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
