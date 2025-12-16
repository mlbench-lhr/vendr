import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String selectedLocale = 'en';

  List<Map<String, dynamic>> locales = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Spanish', 'code': 'es'},
    // {'name': 'French', 'code': 'fr'},
    // {'name': 'German', 'code': 'de'},
    // {'name': 'Chinese (Mandarin)', 'code': 'zh'},
    // {'name': 'Russian', 'code': 'ru'},
    // {'name': 'Portuguese', 'code': 'pt'},
    // {'name': 'Italian', 'code': 'it'},
    // {'name': 'Arabic', 'code': 'ar'},
    // {'name': 'Dutch', 'code': 'nl'},
  ];

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Languages',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ...locales.map((lan) {
              return LanguageItem(
                title: lan['name'],
                code: lan['code'],
                onChanged: (String value) {
                  setState(() {
                    selectedLocale = value;
                  });
                },
                selected: selectedLocale,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class LanguageItem extends StatefulWidget {
  const LanguageItem({
    super.key,
    required this.title,
    required this.code,
    required this.onChanged,
    required this.selected,
  });
  final String title;
  final String code;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  State<LanguageItem> createState() => _LanguageItemState();
}

class _LanguageItemState extends State<LanguageItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(widget.code);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: context.typography.title),
            if (widget.selected == widget.code) Icon(Icons.done),
          ],
        ),
      ),
    );
  }
}
