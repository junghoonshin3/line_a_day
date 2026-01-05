// views/intro/intro_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/config/routes.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/intro/presentation/intro_view_model.dart';
import 'package:line_a_day/features/intro/presentation/state/intro_state.dart';
import 'package:line_a_day/shared/widgets/gradient_container.dart';
import 'package:line_a_day/features/intro/presentation/widgets/intro_bottom_button.dart';
import 'package:line_a_day/features/intro/presentation/widgets/intro_header.dart';
import 'package:line_a_day/features/intro/presentation/widgets/intro_page_content.dart';
import 'package:line_a_day/features/intro/presentation/widgets/intro_page_data.dart';

class IntroView extends ConsumerStatefulWidget {
  const IntroView({super.key});

  @override
  ConsumerState<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends ConsumerState<IntroView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(introViewModelProvider);
    final viewModel = ref.read(introViewModelProvider.notifier);

    // 인트로 완료 상태 감지
    ref.listen<IntroState>(introViewModelProvider, (previous, next) {
      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        _navigateToMain();
      }
    });

    return Scaffold(
      body: GradientContainer(
        gradient: AppTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              // 상단 Skip 버튼
              IntroHeader(
                onSkip: () => _skip(viewModel),
                showSkipButton: !viewModel.isLastPage,
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => viewModel.updatePage(index),
                  itemCount: IntroPageData.pages.length,
                  itemBuilder: (context, index) {
                    return IntroPageContent(data: IntroPageData.pages[index]);
                  },
                ),
              ),

              // 인디케이터 & 버튼
              IntroBottomButton(
                pageController: _pageController,
                pageCount: IntroPageData.pages.length,
                isLastPage: viewModel.isLastPage,
                onButtonPressed: () => _onButtonPressed(viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(IntroViewModel viewModel) {
    if (viewModel.isLastPage) {
      viewModel.completeIntro();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip(IntroViewModel viewModel) {
    _pageController.animateToPage(
      IntroPageData.pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    }
  }
}
