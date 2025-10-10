// views/diary_mood_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_mood_state.dart';
import 'package:line_a_day/features/diary/presentation/mood/diary_mood_view_model.dart';

class DiaryMoodView extends ConsumerStatefulWidget {
  const DiaryMoodView({super.key});

  @override
  ConsumerState<DiaryMoodView> createState() => _DiaryMoodViewState();
}

class _DiaryMoodViewState extends ConsumerState<DiaryMoodView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 각 위젯별로 다른 시작 시간을 가지는 애니메이션 생성
    _fadeAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.15, // 각 위젯이 0.15초 간격으로 시작
            (index * 0.15) + 0.4, // 0.4초 동안 애니메이션
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3), // 위에서 아래로
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.15,
            (index * 0.15) + 0.4,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    // 화면이 빌드된 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryMoodViewModelProvider);
    final viewModel = ref.read(diaryMoodViewModelProvider.notifier);

    // 에러 상태 변화 감지하여 스낵바 표시
    ref.listen<DiaryMoodState>(diaryMoodViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          (previous?.errorMessage != next.errorMessage)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    next.errorMessage!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        // Navigator.of(context).pushNamed("diaryWrite");
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 스크롤 가능한 내용 부분
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    // 헤더 애니메이션 (index: 0)
                    _buildAnimatedWidget(index: 0, child: _buildHeader()),
                    const SizedBox(height: 32),

                    // 기분 그리드 애니메이션 (index: 1)
                    _buildAnimatedWidget(
                      index: 1,
                      child: _buildMoodGrid(context, state, viewModel),
                    ),
                    const SizedBox(height: 32),

                    // 선택된 기분 정보 애니메이션 (index: 2)
                    _buildAnimatedWidget(
                      index: 2,
                      child: _buildSelectedMoodInfo(state),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // 고정된 하단 버튼 부분 애니메이션 (index: 3)
            _buildAnimatedWidget(
              index: 3,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                child: _buildSaveButton(context, state, viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedWidget({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          '오늘의 기분은?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '매일의 기분을 기록하여 감정 패턴을 파악해보세요 ✨',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildMoodGrid(
    BuildContext context,
    DiaryMoodState state,
    DiaryMoodViewModel viewModel,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: Mood.moods.length,
      itemBuilder: (context, index) {
        final mood = Mood.moods[index];
        final isSelected = state.selectedMood == mood.type;

        return GestureDetector(
          onTap: () => viewModel.selectMood(mood.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Color(mood.colorCode),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mood.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  mood.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedMoodInfo(DiaryMoodState state) {
    if (state.selectedMood == null) return const SizedBox.shrink();

    final selectedMood = Mood.getMoodByType(state.selectedMood!);
    if (selectedMood == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '선택된 기분: ',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Text(
            '${selectedMood.label} ${selectedMood.emoji}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    DiaryMoodState state,
    DiaryMoodViewModel viewModel,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => viewModel.saveMood(),
        style: ElevatedButton.styleFrom(
          backgroundColor: state.selectedMood != null
              ? const Color(0xFF3B82F6)
              : const Color(0xFF9CA3AF),
          foregroundColor: Colors.white,
          elevation: state.selectedMood != null ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                '기분 저장하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
