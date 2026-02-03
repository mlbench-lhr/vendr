import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/chat_service.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.time,
    required this.isRecieved,
    super.key,
  });

  final String message;
  final DateTime time;
  final bool isRecieved;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isRecieved
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isRecieved
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.85,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isRecieved
                      ? const Color(0xFF226bf7)
                      : Color(0xFF2e323d),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(isRecieved ? 0 : 16.r),
                    bottomRight: Radius.circular(isRecieved ? 16.r : 0),
                  ),
                ),
                child: Text(
                  message,
                  style: context.typography.body.copyWith(
                    color: context.colors.textOnDark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                if (isRecieved) SizedBox(width: 20.w),
                Text(
                  LiveChatService.formatChatTimestamp(time),
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (!isRecieved) SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ],
    );
  }
}
