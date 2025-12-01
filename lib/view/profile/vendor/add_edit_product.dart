import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key, required this.isEdit});
  final bool isEdit;
  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final List<String> servingTypes = [
    'Single Serving',
    '2 Servings',
    '3 Servings',
    '4 Servings',
    '5 Servings',
  ];
  final List<String> prices = ['\$100', '\$200', '\$300'];
  int servingCount = 1;
  List<Map<String, dynamic>> servings = [
    {'id': 1, 'servingType': 'Single Serving', 'price': '\$100'},
  ];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Menu Item' : 'Upload Menu Item',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 45.r,
                child: Icon(
                  Icons.camera_enhance_outlined,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 36.w,
                ),
              ),
            ),
            8.height,
            Text(
              'Name',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            10.height,
            MyTextField(hint: 'Enter your name'),
            16.height,
            Text(
              'Description',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            10.height,
            MyTextField(maxLines: 5, hint: 'Add product description here...'),
            16.height,
            ...(servings.map((serving) {
              return ServingSection(
                servings: servingTypes,
                prices: prices,
                onRemove: (id) {
                  setState(() {
                    servings.removeWhere((item) => item['id'] == id);
                  });
                  debugPrint('Removed id = $id');
                },
                id: serving['id'] as int,
              );
            })),
            10.height,
            AddNewBtn(
              addServing: () {
                int newId = servings.isNotEmpty ? servings.last['id'] + 1 : 1;
                debugPrint('new ID $newId');
                setState(() {
                  servings.add({
                    'id': newId,
                    'servingType': 'Single Serving',
                    'price': '\$100',
                  });
                });
              },
            ),
            20.height,
            MyButton(label: 'Add', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class AddNewBtn extends StatelessWidget {
  const AddNewBtn({super.key, required this.addServing});
  final VoidCallback addServing;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addServing.call();
        debugPrint('New serving added');
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: context.colors.buttonPrimary),
            Text(
              'Add New',
              style: context.typography.title.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.buttonPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServingSection extends StatelessWidget {
  const ServingSection({
    super.key,
    required this.servings,
    required this.prices,
    required this.onRemove,
    required this.id,
  });

  final int id;
  final List<String> servings;
  final List<String> prices;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serving',
                  style: context.typography.title.copyWith(fontSize: 18.sp),
                ),
                10.height,
                SizedBox(
                  width: 160.w,
                  child: MyDropdown(
                    value: servings.first,
                    items: servings,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: context.typography.title.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(6.r),
                        onTap: () {
                          onRemove(id);
                          debugPrint('THE ID HERE $id');
                        },
                        child: Icon(Icons.close, size: 20.w),
                      ),
                    ],
                  ),
                ),
                10.height,
                SizedBox(
                  width: 140.w,
                  child: MyDropdown(
                    value: prices.first,
                    items: prices,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
