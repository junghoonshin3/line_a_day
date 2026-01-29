import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/shared/widgets/dialogs/app_unified_dialog.dart';
import 'package:line_a_day/shared/widgets/dialogs/app_unified_bottom_sheet.dart';

/// 통합 다이얼로그 헬퍼
/// DialogHelper와 OverlayHelper를 하나로 통합
class AppDialogHelper {
  /// 기본 알림 다이얼로그
  static Future<void> showAlert(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = '확인',
    VoidCallback? onConfirm,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AppUnifiedDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            onConfirm: onConfirm,
          ),
        );
      },
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
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AppUnifiedDialog(
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
      },
    );
    return result ?? false;
  }

  /// 에러 다이얼로그
  static Future<void> showError(
    BuildContext context, {
    String title = '오류',
    required String message,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AppUnifiedDialog(
            title: title,
            message: message,
            icon: Icons.error_outline,
            iconColor: AppTheme.errorRed,
            confirmText: '확인',
            onConfirm: () {},
          ),
        );
      },
    );
  }

  /// 커스텀 컨텐츠 다이얼로그 (OverlayHelper.showDialog 대체)
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AppUnifiedDialog(
            title: title,
            content: content,
            actions: actions,
            showCloseButton: showCloseButton,
          ),
        );
      },
    );
  }

  /// 바텀시트 다이얼로그
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    double? height,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppUnifiedBottomSheet(
        title: title,
        height: height,
        showDragHandle: showDragHandle,
        child: content,
      ),
    );
  }
}
