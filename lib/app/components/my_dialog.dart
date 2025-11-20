import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_outlined_button.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({
    required this.title,
    required this.subtitle,
    super.key,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel,
    this.showCancelButton = true,
  });

  final String title;
  final String subtitle;
  final Future<void> Function()? onConfirm;
  final VoidCallback? onCancel;
  final String? confirmLabel;
  final bool showCancelButton;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) return;
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await widget.onConfirm!();
      // if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Handle error as needed
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: Dialog(
        backgroundColor: context.colors.cardPrimary,
        // backgroundColor: const Color.fromARGB(255, 203, 225, 255),
        alignment: Alignment.bottomCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadiuses.extraLargeRadius),
        ),
        insetPadding: EdgeInsets.all(12.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: context.typography.title.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.primary,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: context.typography.subtitle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  if (widget.showCancelButton) ...[
                    Expanded(
                      child: MyOutlinedButton(
                        label: context.l10n.dialog_cancel,
                        isDark: true,
                        onPressed: _isLoading
                            ? null
                            : (widget.onCancel ??
                                  () => Navigator.of(context).pop()),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  Expanded(
                    child: MyButton(
                      isLoading: _isLoading,
                      isDark: true,
                      label:
                          widget.confirmLabel ?? context.l10n.dialog_yes_delete,
                      onPressed: _isLoading ? null : _handleConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Usage example:
///
/// showDialog<void>(
///   context: context,
///   builder: (_) => MyDialog(
///     title: 'Delete Account?',
///     subtitle: 'This action cannot be undone.',
///     confirmLabel: 'Delete Forever',
///     onConfirm: () async {
///       await deleteAccountApi();
///     },
///   ),
/// );
