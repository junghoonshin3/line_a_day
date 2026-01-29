import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';

class FilterTabs extends StatelessWidget {
  final EmotionType? selectedMood;
  final Function(EmotionType?) onMoodSelected;

  const FilterTabs({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final emotions = Emotion.emotions; // 감정 리스트

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: emotions.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTab('전체', null, context);
          } else if (index == emotions.length + 1) {
            return _buildTab('🏷️ 태그', null, context);
          } else {
            final emotion = emotions[index - 1];
            return _buildTab(
              '${emotion.emoji} ${emotion.label}',
              emotion.type,
              context,
            );
          }
        },
      ),
    );
  }

  Widget _buildTab(String label, EmotionType? mood, BuildContext context) {
    final isSelected = selectedMood == mood;

    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected
              ? null
              : Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkGray700
              : AppTheme.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTheme.labelLarge.copyWith(
            color: isSelected
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                ? AppTheme.gray100
                : AppTheme.darkGray700,
          ),
        ),
      ),
    );
  }
}
