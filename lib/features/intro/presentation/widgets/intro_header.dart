import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

class IntroHeader extends StatelessWidget {
  final VoidCallback onSkip;
  final bool showSkipButton;

  const IntroHeader({
    super.key,
    required this.onSkip,
    this.showSkipButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: showSkipButton,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: AppTheme.titleMedium.copyWith(color: AppTheme.gray600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
