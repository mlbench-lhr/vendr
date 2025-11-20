import 'package:flutter/material.dart';
import 'package:vendr/app/components/my_dialog.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Delete Account?',
      subtitle:
          'Are you sure you want to delete your account? you will lost all your data and you couldn\'t restore this later.',
      confirmLabel: 'Yes Delete',
      onConfirm: () async {
        Navigator.of(context).pop();
      },
    );
  }
}
