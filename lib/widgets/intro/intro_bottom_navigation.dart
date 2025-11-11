import 'package:flutter/material.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/widgets/common/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroBottomNavigation extends StatelessWidget {
  final PageController pageController;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onButtonPressed;

  const IntroBottomNavigation({
    super.key,
    required this.pageController,
    required this.pageCount,
    required this.isLastPage,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Column(
        children: [
          // 페이지 인디케이터
          SmoothPageIndicator(
            controller: pageController,
            count: pageCount,
            effect: WormEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor: AppTheme.primaryBlue,
              dotColor: AppTheme.gray300,
            ),
            onDotClicked: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
          const SizedBox(height: AppTheme.spaceXLarge),

          // 버튼
          CustomButton(
            text: isLastPage ? '시작하기' : '다음',
            onPressed: onButtonPressed,
            width: double.infinity,
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            textStyle: AppTheme.titleMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
