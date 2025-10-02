import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/intro/intro_page_data.dart';

class IntroView extends ConsumerStatefulWidget {
  const IntroView({super.key});

  @override
  ConsumerState<IntroView> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 Skip 버튼
              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Skip',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: IntroPageData.pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(IntroPageData.pages[index]);
                  },
                ),
              ),

              // 인디케이터 & 버튼
              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLarge),
                child: Column(
                  children: [
                    // 페이지 인디케이터
                    _buildPageIndicator(),
                    const SizedBox(height: AppTheme.spaceXLarge),

                    // 다음/시작 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusLarge,
                            ),
                          ),
                        ),
                        child: Text(
                          _currentPage == IntroPageData.pages.length - 1
                              ? '시작하기'
                              : '다음',
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(IntroPageData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이모지/일러스트 (실제로는 Lottie 애니메이션)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Center(
              child: Text(
                data.lottieAsset,
                style: const TextStyle(fontSize: 100),
              ),
            ),
          ),
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
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: data.features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spaceSmall,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceMedium),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        IntroPageData.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: _currentPage == index ? AppTheme.primaryGradient : null,
            color: _currentPage == index ? null : AppTheme.gray300,
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed() {
    if (_currentPage == IntroPageData.pages.length - 1) {
      _finishIntro();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _pageController.animateToPage(
      IntroPageData.pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _finishIntro() {
    // SharedPreferences에 인트로 완료 저장
    // Navigator로 메인 화면 이동
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
