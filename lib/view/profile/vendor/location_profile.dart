import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/location_service.dart'; // Add your service import path

class VendrLocationProfile extends StatefulWidget {
  const VendrLocationProfile({super.key});

  @override
  State<VendrLocationProfile> createState() => _VendrLocationProfileState();
}

class _VendrLocationProfileState extends State<VendrLocationProfile> {
  final VendorLocationService _locationService = VendorLocationService();
  Timer? _timer;
  int selectedSeconds = 7200;
  int remainingSeconds = 0;
  bool isLive = false;
  bool isSwitched = false;
  bool isPaused = false;
  bool _isLocationLoading = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void selectDuration(int seconds) {
    setState(() {
      selectedSeconds = seconds;
    });
  }

  void startTimer() {
    // Check if location is enabled first
    if (!_locationService.isSharing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enable location sharing first'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedSeconds <= 0) return;
    setState(() {
      isLive = true;
      remainingSeconds = selectedSeconds;
      isPaused = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        setState(() {
          isSwitched = false;
        });
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        setState(() {
          isSwitched = false;
        });
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      isLive = false;
      remainingSeconds = 0;
      isPaused = false;
      isSwitched = false;
      _locationService.stopSharing();
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      remainingSeconds = selectedSeconds;
      isPaused = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        setState(() {
          isSwitched = false;
        });
      }
    });
  }

  void addTime(int seconds) {
    setState(() {
      remainingSeconds += seconds;
    });
  }

  Future<void> _toggleLocationSharing() async {
    if (_isLocationLoading) return;

    setState(() => _isLocationLoading = true);

    try {
      if (_locationService.isSharing) {
        await _locationService.stopSharing();
        debugPrint('🛑 Location sharing stopped');

        // If location is turned off, stop the timer
        if (isLive) {
          stopTimer();
        }
      } else {
        await _locationService.startSharing();
        debugPrint('✅ Location sharing started');
      }
    } catch (e) {
      debugPrint('❌ Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) setState(() => _isLocationLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isSharing = _locationService.isSharing;

    return Scaffold(
      appBar: AppBar(title: Text('Location & Visibility')),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color(0xff2E323D),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Color(0xff41454E),
                          child: Icon(
                            isSharing ? Icons.location_on : Icons.location_off,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Live Location',
                              style: context.typography.label.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              isSharing
                                  ? 'Customers can see you on map'
                                  : 'Share your location to be visible',
                              style: context.typography.subtitle.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _isLocationLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Switch(
                            value: isSharing,
                            onChanged: (_) => _toggleLocationSharing(),
                            trackOutlineColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            trackColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Color(0xFF226bf7); // activeTrackColor
                                }
                                return Color(0xFF20232a); // inactiveTrackColor
                              },
                            ),
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 340.h, // Increased to prevent overflow
              child: Opacity(
                opacity: isSharing ? 1.0 : 0.5,
                child: Card(
                  color: Color(0xff2E323D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.w, // Reduced from 30.w
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xff41454E),
                              radius: 24.r,
                              child: Icon(Icons.alarm),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              // Changed from Flexible to Expanded
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Auto-Hide Timer',
                                    style: context.typography.label.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 6.h), // Reduced from 10
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    'Automatically go offline after set time',
                                    style: context.typography.subtitle.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h), // Reduced from 20.h

                        isLive
                            ? SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: Card(
                                  color: Color(0xFF5E636E),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Time Runner',
                                          style: context.typography.label
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                        ),
                                        Text(
                                          formatTime(remainingSeconds),
                                          style: context.typography.label
                                              .copyWith(
                                                color: isPaused
                                                    ? Colors.orange
                                                    : Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Set Duration',
                                    style: context.typography.label.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    formatTime(selectedSeconds),
                                    style: context.typography.title.copyWith(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                        isLive
                            ? SizedBox(height: 20.h)
                            : SizedBox(height: 10.h),
                        isLive
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isPaused
                                        ? 'Timer Paused'
                                        : 'Timer Remaining',
                                    style: context.typography.label.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    formatTime(remainingSeconds),
                                    style: context.typography.label.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: isPaused
                                          ? Colors.orange
                                          : Colors.blue,
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: isSharing
                                          ? () => selectDuration(1800)
                                          : null, // 30 min
                                      child: TimeCard(
                                        timer: '30m',
                                        isSelected: selectedSeconds == 1800,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    GestureDetector(
                                      onTap: isSharing
                                          ? () => selectDuration(3600)
                                          : null, // 1 hour
                                      child: TimeCard(
                                        timer: '1h 0m',
                                        isSelected: selectedSeconds == 3600,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    GestureDetector(
                                      onTap: isSharing
                                          ? () => selectDuration(7200)
                                          : null, // 2 hours
                                      child: TimeCard(
                                        timer: '2h 0m',
                                        isSelected: selectedSeconds == 7200,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    GestureDetector(
                                      onTap: isSharing
                                          ? () => selectDuration(14400)
                                          : null, // 4 hours
                                      child: TimeCard(
                                        timer: '4h 0m',
                                        isSelected: selectedSeconds == 14400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(height: 16.h), // Reduced from 20.h
                        isLive
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 150,
                                    child: MyButton(
                                      onPressed: isSharing
                                          ? (isPaused
                                                ? resumeTimer
                                                : pauseTimer)
                                          : null,
                                      isDark: true,
                                      icon: Icon(
                                        isPaused
                                            ? Icons.play_arrow
                                            : Icons.pause_outlined,
                                        color: Colors.white,
                                      ),
                                      label: isPaused ? 'Resume' : 'Pause',
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    height: 60,
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff20232a),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      onPressed: isSharing ? resetTimer : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Text(
                                            'Reset',
                                            style: context.typography.body
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 15.h, // Changed from .w to .h
                                child: Card(
                                  color: Color(0xff20232A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                        SizedBox(height: 10.h),
                        isLive
                            ? Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => addTime(900),
                                      child: Text(
                                        '+ 15m',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => addTime(1800),
                                      child: Text(
                                        '+ 30m',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => addTime(3600),
                                      child: Text(
                                        '+ 1h',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '30 min',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '2 hrs',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '4 hrs',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                        isLive ? SizedBox.fromSize() : SizedBox(height: 30),
                        isLive
                            ? SizedBox.fromSize()
                            : Flexible(
                                child: MyButton(
                                  onPressed: isSharing ? startTimer : null,
                                  label: isSharing
                                      ? 'Start Timer'
                                      : 'Enable Location First',
                                  icon: Icon(
                                    isSharing
                                        ? Icons.play_arrow
                                        : Icons.location_off,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final String timer;
  final bool isSelected;

  const TimeCard({super.key, required this.timer, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected ? Color(0xFF226bf7) : Color(0xff20232A),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.5.w, vertical: 10.w),
        child: Text(
          timer,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
