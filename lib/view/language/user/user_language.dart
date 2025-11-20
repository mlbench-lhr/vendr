import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/language/user/widgets/language_chip.dart';

class UserLanguageScreen extends StatelessWidget {
  const UserLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Language',
            style: context.typography.title.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: LanguageChip(
                    languageName: 'English',
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Spanish'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'French'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'German'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Chinese'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Japanese'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Russian'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Italian'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Arabic'),
            SizedBox(height: 15.h),
            LanguageChip(languageName: 'Dutch'),
          ],
        ),
      ),
    );
  }
}
