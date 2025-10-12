import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/storage/storage_keys.dart';
import 'package:line_a_day/features/intro/presentation/state/intro_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroViewModel extends StateNotifier<IntroState> {
  IntroViewModel(this._prefs) : super(IntroState());

  final SharedPreferences _prefs;

  void updatePage(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> completeIntro() async {
    try {
      await _prefs.setBool(StorageKeys.hasSeenIntro, true);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      print('인트로 완료 저장 실패: $e');
    }
  }

  void reset() {
    state = IntroState();
  }

  bool get isLastPage => state.currentPage == 3; // 총 4개 페이지 (0~3)
}
