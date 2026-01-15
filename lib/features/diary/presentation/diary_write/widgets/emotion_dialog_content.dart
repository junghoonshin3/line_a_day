import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';

class EmotionDialogContent extends StatelessWidget {
  final ValueChanged<Emotion> onSelect;
  final EmotionType currentEmotion;

  const EmotionDialogContent({
    super.key,
    required this.onSelect,
    required this.currentEmotion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGray700
            : AppTheme.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('오늘의 감정', style: AppTheme.headlineMedium),
                    const SizedBox(height: 2),
                    Text(
                      '지금 느끼는 감정을 선택해주세요',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.gray300
                            : AppTheme.darkGray700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.gray400),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 감정 그리드
          SizedBox(
            height: 420,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: Emotion.emotions.length,
              itemBuilder: (context, index) {
                final emotion = Emotion.emotions[index];
                final isSelected = currentEmotion == emotion.type;

                return GestureDetector(
                  onTap: () {
                    onSelect(emotion);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryPurple
                          : Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkGray900
                          : AppTheme.gray100,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(
                                  emotion.colorCode,
                                ).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emotion.emoji,
                          style: TextStyle(fontSize: isSelected ? 42 : 38),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emotion.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).brightness ==
                                      Brightness.dark
                                ? AppTheme.gray100
                                : AppTheme.darkGray700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
