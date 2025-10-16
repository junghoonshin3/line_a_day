import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            if (title != null) _buildHeader(context),

            // 아이콘
            if (icon != null) _buildIcon(),

            // 컨텐츠
            Padding(
              padding: EdgeInsets.fromLTRB(24, icon != null ? 16 : 24, 24, 24),
              child:
                  content ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message != null)
                        Text(
                          message!,
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.gray700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
            ),

            // 버튼들
            if (onConfirm != null || onCancel != null)
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
      child: Row(
        children: [
          if (title != null)
            Expanded(child: Text(title!, style: AppTheme.headlineMedium)),
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
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AppTheme.primaryBlue,
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
          child: SizedBox(
            child: OutlinedButton(
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop();
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? AppTheme.primaryBlue,
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
        ),
      ],
    );
  }
}
