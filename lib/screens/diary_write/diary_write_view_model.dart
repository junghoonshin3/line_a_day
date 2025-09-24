import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_write_state.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  Timer? _promptTimer;

  final List<String> _prompts = [
    "오늘 하루는 어땠나요?",
    "지금 이 순간, 어떤 기분인가요?",
    "오늘 가장 기억에 남는 순간은?",
    "마음속 깊은 이야기를 들려주세요",
    "오늘 느낀 감정을 한 줄로 표현한다면?",
    "무엇이 당신을 웃게 만들었나요?",
    "오늘 고마웠던 일이 있나요?",
  ];

  DiaryWriteViewModel() : super(DiaryWriteState()) {
    _startPromptRotation();
  }

  void onChangedText(String text) {
    state = state.copyWith(text: text);
  }

  void onChangedPrompt(String text) {
    state = state.copyWith(currentPrompt: text);
  }

  void setWritingState(bool isWriting) {
    state = state.copyWith(isWriting: isWriting);
  }

  // 프롬프트 자동 로테이션
  void _startPromptRotation() {
    _promptTimer?.cancel();
    _promptTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!state.isWriting) {
        final shuffledPrompts = [..._prompts]..shuffle();
        state = state.copyWith(currentPrompt: shuffledPrompts.first);
      }
    });
  }
}

final diaryWriteViewModelProvider =
    StateNotifierProvider<DiaryWriteViewModel, DiaryWriteState>((ref) {
      return DiaryWriteViewModel();
    });
