import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';

/// 공통 정보 칩 위젯
class InfoChip extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback? onTap;
  final bool showBorder;

  const InfoChip({
    super.key,
    this.icon,
    this.emoji,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: showBorder ? Border.all(color: bgColor.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 14, color: textColor)
          else if (emoji != null)
            Text(emoji!, style: const TextStyle(fontSize: 14)),
          if (icon != null || emoji != null) const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.labelMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}

/// 미리 정의된 스타일의 정보 칩들
class WeatherChip extends StatelessWidget {
  final String emoji;
  final String label;

  const WeatherChip({super.key, required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return InfoChip(
      emoji: emoji,
      label: label,
      bgColor: const Color(0xFFFEF3C7),
      textColor: const Color(0xFFD97706),
    );
  }
}

class LocationChip extends StatelessWidget {
  final String location;

  const LocationChip({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return InfoChip(
      emoji: '📍',
      label: location,
      bgColor: const Color(0xFFDBEAFE),
      textColor: const Color(0xFF2563EB),
    );
  }
}

class TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback? onDelete;

  const TagChip({super.key, required this.tag, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (onDelete != null) {
      return Chip(
        label: Text(tag),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDelete,
        backgroundColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        deleteIconColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      );
    }

    return InfoChip(
      label: '#$tag',
      bgColor: const Color(0xFFF3E8FF),
      textColor: const Color(0xFF9333EA),
    );
  }
}

class EmotionChip extends StatelessWidget {
  final String emoji;
  final String label;

  const EmotionChip({super.key, required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return InfoChip(
      emoji: emoji,
      label: label,
      bgColor: const Color(0xFFFDA4AF),
      textColor: const Color(0xFFE11D48),
    );
  }
}
