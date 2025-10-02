import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_mood_state.dart';
import '/model/mood.dart';

class DiaryMoodViewModel extends StateNotifier<DiaryMoodState> {
  DiaryMoodViewModel() : super(DiaryMoodState());

  void selectMood(MoodType mood) {
    state = state.copyWith(selectedMood: mood, errorMessage: null);
  }

  void clearSelection() {
    state = state.copyWith(selectedMood: null, errorMessage: null);
  }

  void resetState() {
    state = DiaryMoodState();
  }

  Future<void> saveMood() async {
    if (state.selectedMood == null) {
      state = state.copyWith(errorMessage: '기분을 선택해주세요!');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 여기에 실제 저장 로직 추가 (API 호출, 로컬 DB 저장 등)
      await Future.delayed(const Duration(milliseconds: 500)); // 시뮬레이션

      final selectedMood = Mood.getMoodByType(state.selectedMood!);
      print('기분 저장됨: ${selectedMood?.label} ${selectedMood?.emoji}');

      state = state.copyWith(isLoading: false, isCompleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '기분 저장 중 오류가 발생했습니다.',
      );
    }
  }

  Mood? get selectedMoodData {
    if (state.selectedMood == null) return null;
    return Mood.getMoodByType(state.selectedMood!);
  }
}

final diaryMoodViewModelProvider =
    StateNotifierProvider.autoDispose<DiaryMoodViewModel, DiaryMoodState>(
      (ref) => DiaryMoodViewModel(),
    );
