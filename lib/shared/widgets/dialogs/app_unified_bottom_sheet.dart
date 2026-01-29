import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

/// 통합 바텀시트 위젯
/// AppBottomSheet와 CustomBottomSheet를 통합
/// 다크모드 지원, height 커스터마이징, dragHandle 옵션 제공
class AppUnifiedBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final bool showDragHandle;

  const AppUnifiedBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: height,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkGray700 : AppTheme.gray100,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            if (showDragHandle) _buildDragHandle(),

            // title
            if (title != null) _buildTitle(context),

            // content
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title!,
        style: AppTheme.headlineMedium.copyWith(
          color: isDarkMode ? AppTheme.gray100 : AppTheme.darkGray700,
        ),
      ),
    );
  }
}
