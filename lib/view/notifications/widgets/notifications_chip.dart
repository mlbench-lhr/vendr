import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/general/notification_model.dart';

class NotificationsChip extends StatefulWidget {
  final NotificationModel notification;
  const NotificationsChip({super.key, required this.notification});

  @override
  State<NotificationsChip> createState() => _NotificationsChipState();
}

class _NotificationsChipState extends State<NotificationsChip> {
  IconData notificationIcon = Icons.person;

  @override
  void initState() {
    super.initState();
    setIcon();
  }

  void setIcon() {
    //return if null
    if (widget.notification.data == null ||
        widget.notification.data!.type == null) {
      return;
    }
    //set notification icon
    final type = widget.notification.data!.type;
    //new vendor alert
    if (type == 'new_vendor_nearby') {
      setState(() {
        notificationIcon = Icons.storefront;
      });
    }
    //distance based alert
    else if (type == 'distance_based') {
      setState(() {
        notificationIcon = Icons.near_me;
      });
    }
    //favorite vendor alert
    else if (type == 'favorite_vendor') {
      setState(() {
        notificationIcon = Icons.favorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        widget.notification.image != null && widget.notification.image != '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.white54,
          child: CircleAvatar(
            radius: 19.r,
            backgroundColor: context.colors.primary,
            backgroundImage: hasImage
                ? NetworkImage(widget.notification.image!)
                : null,
            child: hasImage
                ? null // image will show automatically
                : Icon(notificationIcon, color: Colors.white, size: 24.r),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.notification.title,
                style: context.typography.title.copyWith(fontSize: 16.sp),
              ),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                widget.notification.body,
                style: context.typography.label.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(formatTime(widget.notification.createdAt)),
            Text(formatDate(widget.notification.createdAt)),
          ],
        ),
      ],
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
  }

  // Returns time in hh:mm (24-hour) format
  String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
