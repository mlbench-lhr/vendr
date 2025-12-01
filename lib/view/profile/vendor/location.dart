import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/view/profile/widgets/location_chip.dart';

class VendorLocationScreen extends StatefulWidget {
  const VendorLocationScreen({super.key});

  @override
  State<VendorLocationScreen> createState() => _VendorLocationScreenState();
}

class _VendorLocationScreenState extends State<VendorLocationScreen> {
  bool isFixed = true;

  final addLocationController = TextEditingController();
  final setLocationController = TextEditingController();

  List<String> locations = [];

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Location',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LocationTypeSwitch(
                onChanged: (bool value) {
                  debugPrint('Value: $value');
                  setState(() {
                    isFixed = value;
                  });
                },
              ),
              SizedBox(height: 24.h),
              isFixed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set Location',
                          style: context.typography.title.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        MyTextField(
                          controller: setLocationController,
                          hint: 'Enter Location',
                          suffixIcon: Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Location',
                          style: context.typography.title.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        MyTextField(
                          controller: addLocationController,
                          hint: 'Enter Location',
                          suffixIcon: InkWell(
                            onTap: () {
                              debugPrint('Location added');
                            },
                            child: IconButton(
                              onPressed: () {
                                _addLocation();
                              },
                              icon: Icon(Icons.add, color: Colors.blue),
                            ),
                          ),
                          onSubmitted: (value) {
                            _addLocation();
                          },
                        ),
                        SizedBox(height: 16.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 10.h,
                          children: [
                            ...locations.map((l) {
                              return LocationChip(
                                label: l,
                                onDelete: () {
                                  setState(() {
                                    locations.remove(l);
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 32.w),
        child: MyButton(label: 'Update', onPressed: () {}),
      ),
    );
  }

  void _addLocation() {
    if (addLocationController.text.isNotEmpty) {
      setState(() {
        locations.add(addLocationController.text);
        addLocationController.clear();
      });
    } else {
      context.flushBarErrorMessage(message: 'Please enter a valid address.');
    }
  }
}

class LocationTypeSwitch extends StatefulWidget {
  const LocationTypeSwitch({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;
  @override
  State<LocationTypeSwitch> createState() => _LocationTypeSwitchState();
}

class _LocationTypeSwitchState extends State<LocationTypeSwitch> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: value,
      // children: const {0: Text('Fixed'), 1: Text('Remote')},
      children: const {
        0: Row(
          children: [
            SizedBox(width: 22),
            Icon(Icons.store),
            SizedBox(width: 6),
            Text('Fixed'),
          ],
        ),
        1: Row(
          children: [
            SizedBox(width: 18),
            Icon(Icons.route),
            SizedBox(width: 6),
            Text('Remote'),
          ],
        ),
      },
      onValueChanged: (v) {
        setState(() => value = v!);
        //notify by callback
        widget.onChanged(value == 0);
      },
      thumbColor: context.colors.buttonPrimary,
    );
  }
}
