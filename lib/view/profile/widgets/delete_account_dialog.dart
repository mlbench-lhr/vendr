import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_dialog.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Delete Account?',
      subtitle:
          'Are you sure you want to delete your account? All the account details will be deleted Permanently.',
      confirmLabel: 'Delete',
      onConfirm: () async {
        Navigator.of(context).pop();
      },
    );
  }
}
