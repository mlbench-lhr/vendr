import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/services/user/user_home_service.dart';
import 'package:vendr/services/user/user_profile_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      UserProfileService.gotoUserProfile(context);
                    },
                    child: CircleAvatar(radius: 45.r),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      UserHomeService.gotoSearch(context);
                    },
                    icon: Icon((Icons.search)),
                  ),
                  IconButton(
                    onPressed: () {
                      UserHomeService.gotoNotifications(context);
                    },
                    icon: Icon(Icons.notifications),
                  ),
                ],
              ),

              200.height,
              Text('User Home'),
            ],
          ),
        ),
      ),
    );
  }
}
