import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;

  const AppBottomSheet({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkGray700
              : AppTheme.gray100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.gray100
                      : AppTheme.darkGray700,
                ),
              ),
              const SizedBox(height: 16),
            ],

            /// 🔥 컨텐트 주입
            child,
          ],
        ),
      ),
    );
  }
}
