import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/widgets/common/dialog/bottom_sheet_dialog.dart';
import 'package:line_a_day/widgets/common/dialog/custom_dialog.dart';
import 'package:line_a_day/widgets/common/dialog/delete_dialog.dart';
import 'package:line_a_day/widgets/common/dialog/loading_dialog.dart';
import 'package:line_a_day/widgets/common/dialog/success_dialog.dart';

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
  }) async {
    final result = await showDialog<bool>(
      barrierDismissible: false,
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

  /// 삭제 확인 다이얼로그
  static Future<bool> showDeleteConfirm(
    BuildContext context, {
    String title = '삭제 확인',
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DeleteConfirmDialog(title: title, message: message, onConfirm: () {}),
    );
    return result ?? false;
  }

  /// 로딩 다이얼로그 표시
  static void showLoading(BuildContext context, {String message = '처리 중...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// 로딩 다이얼로그 닫기
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 성공 다이얼로그
  static Future<void> showSuccess(
    BuildContext context, {
    String title = '성공',
    required String message,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) =>
          SuccessDialog(title: title, message: message, onConfirm: onConfirm),
    );
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

  // /// 입력 다이얼로그
  // static Future<String?> showInput(
  //   BuildContext context, {
  //   required String title,
  //   String? hint,
  //   String? initialValue,
  //   int maxLines = 1,
  //   int? maxLength,
  // }) {
  //   return showDialog<String>(
  //     context: context,
  //     builder: (context) => InputDialog(
  //       title: title,
  //       hint: hint,
  //       initialValue: initialValue,
  //       maxLines: maxLines,
  //       maxLength: maxLength,
  //       onConfirm: (value) {},
  //     ),
  //   );
  // }

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
      backgroundColor: Colors.transparent,
      builder: (context) => CustomBottomSheet(
        title: title,
        height: height,
        showDragHandle: showDragHandle,
        child: child,
      ),
    );
  }
}
