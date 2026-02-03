import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/services/common/chat_service.dart';

class WriteAndSend extends StatefulWidget {
  const WriteAndSend({
    required this.chatId,
    required this.yourId,
    required this.yourName,
    required this.receiverId,
    super.key,
  });
  final String chatId;
  final String yourId;
  final String yourName;
  final String receiverId;
  @override
  State<WriteAndSend> createState() => _WriteAndSendState();
}

class _WriteAndSendState extends State<WriteAndSend> {
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: MediaQuery.of(context).viewPadding.bottom + 10.h,
      ),
      decoration: BoxDecoration(color: Color(0xFF2e323d)),
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: 283.w,
            child: MyFormTextField(
              textCapitalization: TextCapitalization.none,
              controller: _messageController,
              isDark: false,
              hint: "Type a message...",
              hintColor: Colors.white,
              textColor: Colors.white,
              backgroundColor: Color(0xFF20232a),
              onFieldSubmitted: (value) {
                submitMessage(context);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            alignment: Alignment.center,
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: IconButton(
              onPressed: () {
                submitMessage(context);
              },
              icon: Assets.icons.sendMessage.svg(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void submitMessage(BuildContext context) {
    LiveChatService().sendMessage(
      context,
      widget.chatId,
      _messageController.text.trim(),
      widget.yourId,
      widget.yourName,
      widget.receiverId,
    );
    _messageController.clear();
  }
}
