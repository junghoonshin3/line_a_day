import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

enum SnackBarType { success, error, info, warning }

class CustomSnackBar {
  /// 성공 스낵바
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackBarType.success);
  }

  /// 에러 스낵바
  static void showError(BuildContext context, String message) {
    _show(context, message, SnackBarType.error);
  }

  /// 정보 스낵바
  static void showInfo(BuildContext context, String message) {
    _show(context, message, SnackBarType.info);
  }

  /// 경고 스낵바
  static void showWarning(BuildContext context, String message) {
    _show(context, message, SnackBarType.warning);
  }

  /// 공통 스낵바 표시 로직
  static void _show(BuildContext context, String message, SnackBarType type) {
    final config = _getConfig(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 타입별 설정 반환
  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          icon: Icons.check_circle,
          backgroundColor: AppTheme.primaryBlue,
        );
      case SnackBarType.error:
        return const _SnackBarConfig(
          icon: Icons.error_outline,
          backgroundColor: AppTheme.errorRed,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          icon: Icons.info_outline,
          backgroundColor: AppTheme.primaryBlue,
        );
      case SnackBarType.warning:
        return const _SnackBarConfig(
          icon: Icons.warning_amber_rounded,
          backgroundColor: AppTheme.warningYellow,
        );
    }
  }
}

/// 스낵바 설정 클래스
class _SnackBarConfig {
  final IconData icon;
  final Color backgroundColor;

  const _SnackBarConfig({required this.icon, required this.backgroundColor});
}
