import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

class BackupRestoreDialogContent extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final Color? iconColor;

  const BackupRestoreDialogContent({
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
    // Dialog 위젯으로 감싸서 기본적인 다이얼로그 스타일을 적용합니다.
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGray700
            : AppTheme.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) _buildIcon(),

          // 3. 컨텐츠 (커스텀 위젯 우선, 없으면 기본 메시지)
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.gray100
                              : AppTheme.darkGray700,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
          ),

          // 4. 하단 버튼 영역
          if (onConfirm != null || onCancel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _buildButtons(context),
            ),
        ],
      ),
    );
  }

  // --- 내부 빌드 메서드들 ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 8, 0), // 닫기 버튼 배치를 고려한 패딩
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
    // 취소 버튼이 없는 경우 (확인 버튼만 꽉 차게 표시)
    if (onCancel == null) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AppTheme.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: Text(
            confirmText,
            style: AppTheme.titleMedium.copyWith(color: Colors.white),
          ),
        ),
      );
    }

    // 취소 + 확인 버튼 나란히 배치
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                onCancel?.call();
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.gray300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
              ),
              child: Text(
                cancelText,
                style: AppTheme.titleMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.gray100
                      : AppTheme.darkGray900,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
              ),
              child: Text(
                confirmText,
                style: AppTheme.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
