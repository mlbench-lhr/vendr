import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/general/notification_model.dart';
import 'package:vendr/services/common/notifications_service.dart';
import 'package:vendr/view/notifications/widgets/notifications_chip.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notificationsService = NotificationsService();

  Future<List<NotificationModel>> fetchNotifications() async {
    return await _notificationsService.getNotifications(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder<List<NotificationModel>>(
          future: fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load notifications',
                  style: context.typography.body,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No notifications available',
                  style: context.typography.body,
                ),
              );
            } else {
              final notifications = snapshot.data!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: NotificationsChip(
                      imageUrl: notification.image,
                      title: notification.title,
                      description: notification.body,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
