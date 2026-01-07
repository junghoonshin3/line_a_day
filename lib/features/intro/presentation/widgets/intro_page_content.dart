import 'package:flutter/material.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/features/intro/presentation/widgets/intro_page_data.dart';
import 'package:line_a_day/shared/widgets/feature_check_item.dart';

class IntroPageContent extends StatelessWidget {
  final IntroPageData data;

  const IntroPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이모지/일러스트
          _buildIllustration(),
          const SizedBox(height: AppTheme.spaceXLarge),

          // 제목
          Text(
            data.title,
            style: AppTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceMedium),

          // 설명
          Text(
            data.description,
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.gray600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceXLarge),

          // 기능 리스트
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Center(
        child: Text(data.lottieAsset, style: const TextStyle(fontSize: 100)),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: data.features.map((feature) {
          return FeatureCheckItem(
            text: feature,
            iconGradient: AppTheme.primaryGradient,
            textStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.gray700),
            spacing: AppTheme.spaceMedium,
          );
        }).toList(),
      ),
    );
  }
}
