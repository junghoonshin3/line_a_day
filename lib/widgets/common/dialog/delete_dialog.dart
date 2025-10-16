import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/widgets/common/dialog/custom_dialog.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    super.key,
    this.title = '삭제 확인',
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: Icons.delete_outline,
      iconColor: AppTheme.errorRed,
      title: title,
      message: message,
      confirmText: '삭제',
      cancelText: '취소',
      confirmColor: AppTheme.errorRed,
      onConfirm: onConfirm,
      onCancel: () {},
    );
  }
}
