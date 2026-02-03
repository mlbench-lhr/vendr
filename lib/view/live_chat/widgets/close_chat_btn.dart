import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_dialog.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/chat_service.dart';

class CloseChatBtn extends StatelessWidget {
  const CloseChatBtn({
    required this.chatId,
    required this.currentUserId,
    super.key,
  });
  final String chatId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _showCloseChatDialog(context, chatId);
      },
      child: Container(
        padding: EdgeInsets.all(7.w),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: context.colors.cardPrimary,
        ),
        child: Text(
          "Close Chat",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.textOnLight,
          ),
        ),
      ),
    );
  }

  Future<void> _showCloseChatDialog(BuildContext context, String chatId) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        subtitle: "Are you sure you want to close this chat?",
        confirmLabel: "Close",
        onConfirm: () async {
          Navigator.of(context).pop();
          await LiveChatService().closeChat(context, chatId);
          if (context.mounted) {
            debugPrint('Chat closed successfully!');
          }
        },
        title: "Close Chat",
      ),
    );
  }
}
