import 'package:flutter/material.dart';

class FeatureCheckItem extends StatelessWidget {
  final String text;
  final Gradient? iconGradient;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double spacing;

  const FeatureCheckItem({
    super.key,
    required this.text,
    this.iconGradient,
    this.iconColor,
    this.textStyle,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: iconGradient,
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          SizedBox(width: spacing),
          Expanded(child: Text(text, style: textStyle)),
        ],
      ),
    );
  }
}
