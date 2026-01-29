import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

/// 통합 다이얼로그 위젯
/// CustomDialog의 다크모드 지원과 아이콘 gradient 스타일을 유지하면서
/// AppDialog의 유연한 actions 파라미터를 추가
class AppUnifiedDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final IconData? icon;
  final Color? iconColor;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final List<Widget>? actions;
  final bool showCloseButton;

  const AppUnifiedDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.icon,
    this.iconColor,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.actions,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkGray700 : AppTheme.gray100,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            if (title != null || showCloseButton) _buildHeader(context),

            // 아이콘
            if (icon != null) _buildIcon(),

            // 컨텐츠
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, icon != null ? 16 : 24, 24, 24),
                child: content ??
                    (message != null
                        ? Text(
                            message!,
                            style: AppTheme.bodyLarge.copyWith(
                              color: isDarkMode
                                  ? AppTheme.gray100
                                  : AppTheme.darkGray700,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink()),
              ),
            ),

            // 액션 버튼들
            if (actions != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(children: actions!),
              )
            else if (onConfirm != null || onCancel != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _buildButtons(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (title != null)
            Center(
              child: Text(
                title!,
                style: AppTheme.headlineMedium.copyWith(
                  color: isDarkMode ? AppTheme.gray100 : AppTheme.darkGray700,
                ),
              ),
            ),
          if (showCloseButton)
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: isDarkMode ? AppTheme.gray100 : AppTheme.gray600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor ?? AppTheme.primaryBlue,
            (iconColor ?? AppTheme.primaryPurple).withOpacity(0.8),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (onCancel == null) {
      // 확인 버튼만
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: Text(
            confirmText!,
            style: AppTheme.titleMedium.copyWith(color: Colors.white),
          ),
        ),
      );
    }

    // 취소 + 확인 버튼
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.gray300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
            ),
            child: Text(
              cancelText!,
              style: AppTheme.titleMedium.copyWith(color: AppTheme.gray600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmButtonColor ?? AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
            ),
            child: Text(
              confirmText!,
              style: AppTheme.titleMedium.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
