import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_dialog.dart';
import 'package:vendr/services/common/auth_service.dart';

class LogoutAccountDialog extends StatelessWidget {
  const LogoutAccountDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Logout Account?',
      subtitle: 'Are you sure you want to logout your account?',
      confirmLabel: 'Logout',
      onConfirm: () async {
        AuthService.logout(context);
      },
    );
  }
}
