import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/screens/diary_write/diary_write_view_model.dart';

class DiaryWriteView extends ConsumerStatefulWidget {
  const DiaryWriteView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends ConsumerState<DiaryWriteView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _focusNode.addListener(() {
      ref
          .read(diaryWriteViewModelProvider.notifier)
          .setWritingState(_focusNode.hasFocus);
    });

    _textController.addListener(() {
      ref
          .read(diaryWriteViewModelProvider.notifier)
          .onChangedText(_textController.text);
    });

    _startAnimations();
    // _rotatePrompts();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeGreeting = _getTimeGreeting();
    final dateString =
        "${now.month}월 ${now.day}일 ${_getKoreanDayOfWeek(now.weekday)}";
    final writeState = ref.watch(diaryWriteViewModelProvider);

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C2541),
        body: SafeArea(
          child: Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timeGreeting,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFECEFF4),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateString,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF9CAAC0),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 120,
                                          child: Text(
                                            writeState.currentPrompt,
                                            key: ValueKey(
                                              writeState.currentPrompt,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFECEFF4),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Expanded(
                              child: Column(
                                children: [
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        autocorrect: false,
                                        controller: _textController,
                                        focusNode: _focusNode,
                                        maxLines: 6,
                                        minLines: 4,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1E1E1E),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 작성 중일 때 추가 UI
                                  const SizedBox(height: 30),
                                  AnimatedOpacity(
                                    opacity: writeState.isWriting ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: AnimatedSlide(
                                      offset: writeState.isWriting
                                          ? Offset.zero
                                          : const Offset(0, 0.2),
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "솔직한 마음이 가장 아름다워요 ✨",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(
                                                0xFF007AFF,
                                              ).withOpacity(0.8),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildEmotionChip("😊", "기쁨"),
                                              _buildEmotionChip("😔", "우울"),
                                              _buildEmotionChip("😤", "화남"),
                                              _buildEmotionChip("😴", "피곤"),
                                              _buildEmotionChip("🥰", "사랑"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: writeState.text.isNotEmpty
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF3A506B),
                                            Color(0xFF5BC0BE),
                                          ],
                                        )
                                      : null,
                                  color: writeState.text.isNotEmpty
                                      ? const Color(0xFF3A506B)
                                      : const Color(0xFF2E3A59),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: writeState.text.isNotEmpty
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF5BC0BE,
                                            ).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: writeState.text.isNotEmpty
                                        ? () {
                                            // 저장 로직
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "소중한 하루가 기록되었어요 💫",
                                                ),
                                                backgroundColor: Color(
                                                  0xFFD6B488,
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "오늘 하루 기록하기",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: writeState.text.isNotEmpty
                                              ? Colors.white
                                              : const Color(0xFFAAAAAA),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionChip(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        _textController.text += " $emoji";
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "좋은 아침이에요";
    } else if (hour < 18) {
      return "좋은 오후예요";
    } else {
      return "좋은 저녁이에요";
    }
  }

  String _getKoreanDayOfWeek(int weekday) {
    const days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    return days[weekday - 1];
  }
}
