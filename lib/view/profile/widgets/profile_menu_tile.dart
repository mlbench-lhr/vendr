import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.showArrow = true,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Future.delayed(Duration(milliseconds: 150));
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white24,
              child: Icon(icon, color: Colors.white, size: 20.w),
            ),
            SizedBox(width: 12.w),
            Text(title, style: context.typography.title.copyWith()),
            const Spacer(),
            if (showArrow) Icon(Icons.arrow_forward_ios, size: 18.w),
          ],
        ),
      ),
    );
  }
}
