import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/config/routes.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/emoji/presentation/select/emoji_select_view_model.dart';
import 'package:line_a_day/features/emoji/presentation/select/state/emoji_select_state.dart';
import 'package:line_a_day/shared/widgets/dialogs/custom_snackbar.dart';
import 'package:line_a_day/shared/widgets/indicators/loading_indicator.dart';
import 'package:line_a_day/shared/widgets/animtation/staggered_animation_mixin.dart';

class EmojiSelectView extends ConsumerStatefulWidget {
  const EmojiSelectView({super.key});

  @override
  ConsumerState<EmojiSelectView> createState() => _EmojiSelectViewState();
}

class _EmojiSelectViewState extends ConsumerState<EmojiSelectView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emojiSelectViewModelProvider);
    final viewModel = ref.read(emojiSelectViewModelProvider.notifier);

    // 상태 변화 감지
    ref.listen<EmojiSelectState>(emojiSelectViewModelProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null &&
          (previous?.errorMessage != next.errorMessage)) {
        CustomSnackBar.showError(context, next.errorMessage!);
      }
      if (next.isCompleted) {
        _navigateToDiaryList();
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      // 헤더 (index: 0)
                      buildAnimatedItem(index: 0, child: _buildHeader()),
                      const SizedBox(height: 40),

                      // 이모지 스타일 카드들 (index: 1, 2, 3)
                      ...List.generate(EmojiStyleData.styles.length, (i) {
                        final styleData = EmojiStyleData.styles[i];
                        return buildAnimatedItem(
                          index: i + 1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildEmojiStyleCard(
                              styleData,
                              state.selectedStyle == styleData.style,
                              viewModel,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 하단 버튼 (index: 4)
              buildAnimatedItem(
                index: 4,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _buildSelectButton(state, viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.emoji_emotions,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '이모지 스타일 선택',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '원하는 스타일의 이모지를 선택하세요',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildEmojiStyleCard(
    EmojiStyleData styleData,
    bool isSelected,
    EmojiSelectViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () => viewModel.selectStyle(styleData.style),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  styleData.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFF374151),
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: styleData.images.map((imagePath) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(
    EmojiSelectState state,
    EmojiSelectViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => viewModel.confirmSelection(),
        style: ElevatedButton.styleFrom(
          backgroundColor: state.selectedStyle != null
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF9CA3AF),
          foregroundColor: Colors.white,
          elevation: state.selectedStyle != null ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isLoading
            ? const LoadingIndicator(size: 24, color: Colors.white)
            : const Text(
                '선택 완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  void _navigateToDiaryList() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    });
  }
}
