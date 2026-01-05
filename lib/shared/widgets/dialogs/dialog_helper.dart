import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/shared/widgets/dialogs/custom_bottomsheet.dart';
import 'package:line_a_day/shared/widgets/dialogs/custom_dialog.dart';

class DialogHelper {
  /// 기본 알림 다이얼로그
  static Future<void> showAlert(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = '확인',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// 확인/취소 다이얼로그
  static Future<bool> showConfirm(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    IconData? icon,
    Color? iconColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
  }) async {
    final result = await showDialog<bool>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
    return result ?? false;
  }

  /// 에러 다이얼로그
  static Future<void> showError(
    BuildContext context, {
    String title = '오류',
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        icon: Icons.error_outline,
        iconColor: AppTheme.errorRed,
        confirmText: '확인',
        onConfirm: () {},
      ),
    );
  }

  /// 하단 시트 다이얼로그
  static Future<T?> showBottomSheetDialog<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    double? height,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CustomBottomSheet(
        title: title,
        height: height,
        showDragHandle: showDragHandle,
        child: child,
      ),
    );
  }
}
