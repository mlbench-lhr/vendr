import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/home/user/widgets/search_chip.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            MyTextField(
              prefixIcon: Icon(Icons.search),
              borderRadius: 30,
              hint: 'e.g., Food Vendor',
            ),
            SizedBox(height: 30.h),
            SearchChip(label: 'Fruite Vendor'),
            SizedBox(height: 20.h),
            SearchChip(label: 'Fast Food Vendor'),
          ],
        ),
      ),
    );
  }
}
