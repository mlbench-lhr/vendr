import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key, required this.isEdit});
  final bool isEdit;
  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final List<String> servings = ['Single Serving', '2 Servings', '3 Servings'];
  final List<String> prices = ['\$100', '\$200', '\$300'];

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Product' : 'Upload Product',
          style: context.typography.title.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
            Text(
              'Name',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 10.h),
            MyTextField(),
            SizedBox(height: 16.h),
            Text(
              'Description',
              style: context.typography.title.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 10.h),
            MyTextField(maxLines: 5),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Serving',
                      style: context.typography.title.copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 10.h),
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
                    Text(
                      'Price',
                      style: context.typography.title.copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 160.w,
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
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                debugPrint('New serving added');
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: context.colors.buttonPrimary),
                    Text(
                      'ADD NEW',
                      style: context.typography.title.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.buttonPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            MyButton(label: 'Add', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
