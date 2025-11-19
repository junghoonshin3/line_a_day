import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final bool showDragHandle;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _buildDragHandle(),
          if (title != null) _buildTitle(),
          Flexible(child: child),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(title!, style: AppTheme.headlineMedium),
    );
  }
}
