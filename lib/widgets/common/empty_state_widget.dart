import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

/// 공통 Empty State 위젯
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.gray300.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.gray400,
              height: 1.6,
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// 검색 결과 없음 위젯
class SearchEmptyWidget extends StatelessWidget {
  final String? customMessage;

  const SearchEmptyWidget({super.key, this.customMessage});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      message: customMessage ?? '검색 결과가 없습니다\n다른 키워드로 검색해보세요',
    );
  }
}

/// 데이터 없음 위젯
class NoDataWidget extends StatelessWidget {
  final String? customMessage;
  final String? actionText;
  final VoidCallback? onAction;

  const NoDataWidget({
    super.key,
    this.customMessage,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      message: customMessage ?? '데이터가 없습니다',
      actionText: actionText,
      onAction: onAction,
    );
  }
}
