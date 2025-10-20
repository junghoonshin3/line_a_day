import 'package:flutter/material.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';

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
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildTab('전체', null),
          const SizedBox(width: 8),
          _buildTab('😊 행복', EmotionType.happy),
          const SizedBox(width: 8),
          _buildTab('😢 슬픔', EmotionType.sad),
          const SizedBox(width: 8),
          _buildTab('😤 화남', EmotionType.angry),
          const SizedBox(width: 8),
          _buildTab('🏷️ 태그', null),
        ],
      ),
    );
  }

  Widget _buildTab(String label, EmotionType? mood) {
    final isSelected = selectedMood == mood;

    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTheme.labelLarge.copyWith(
            color: isSelected ? Colors.white : AppTheme.gray600,
          ),
        ),
      ),
    );
  }
}
