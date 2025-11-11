import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

class CardSection extends StatelessWidget {
  const CardSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: child,
    );
  }
}
