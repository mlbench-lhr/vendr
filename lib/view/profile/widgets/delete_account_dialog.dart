import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_dialog.dart';
import 'package:vendr/services/common/auth_service.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key, required this.isVendor});

  final bool isVendor;
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MyDialog(
      title: 'Delete Account?',
      subtitle:
          'Are you sure you want to delete your account? All the account details will be deleted Permanently.',
      confirmLabel: 'Delete',
      onConfirm: () async {
        authService.deleteAccount(context, isVendor: isVendor);
      },
    );
  }
}
