import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final DiaryModel model;
  final VoidCallback onTap;
  const DiaryCard({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(model.emotion),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildPreview(),
            if (model.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildTags(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EmotionType type) {
    final timeString = DateFormat('a h:mm').format(model.createdAt);
    return Row(
      children: [
        Text(
          "${Emotion.getMoodByType(type)?.emoji}",
          style: const TextStyle(fontSize: 32),
        ),
        const Spacer(),
        Text(
          timeString,
          style: AppTheme.labelMedium.copyWith(color: AppTheme.gray400),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      model.title,
      style: AppTheme.titleLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPreview() {
    return Text(
      model.content,
      style: AppTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (model.weather != null)
          _buildTag(
            model.weather?.name ?? "",
            const Color(0xFFFEF3C7),
            const Color(0xFFD97706),
          ),
        if (model.location != null)
          _buildTag(
            '📍 ${model.location!}',
            const Color(0xFFDBEAFE),
            const Color(0xFF2563EB),
          ),
        ...model.tags.map(
          (tag) => _buildTag(
            '#$tag',
            const Color(0xFFF3E8FF),
            const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppTheme.labelMedium.copyWith(color: textColor)),
    );
  }
}
