import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/model/mood.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntity entity;
  final VoidCallback onTap;

  const DiaryCard({super.key, required this.entity, required this.onTap});

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
            _buildHeader(),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildPreview(),
            if (entity.tags?.isNotEmpty ??
                false || entity.weather != null || entity.location != null) ...[
              const SizedBox(height: 12),
              _buildTags(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final timeString = DateFormat('a h:mm').format(entity.createdAt);
    return Row(
      children: [
        Text(
          Mood.getMoodByType(entity.mood)?.emoji ?? '😊',
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
      entity.title,
      style: AppTheme.titleLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPreview() {
    return Text(
      entity.content,
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
        if (entity.weather != null)
          _buildTag(
            entity.weather!,
            const Color(0xFFFEF3C7),
            const Color(0xFFD97706),
          ),
        if (entity.location != null)
          _buildTag(
            '📍 ${entity.location!}',
            const Color(0xFFDBEAFE),
            const Color(0xFF2563EB),
          ),
        ...?entity.tags?.map(
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
