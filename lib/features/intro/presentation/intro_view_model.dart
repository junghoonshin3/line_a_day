import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/di/di.dart';
import 'package:line_a_day/features/intro/presentation/state/intro_state.dart';

class IntroViewModel extends StateNotifier<IntroState> {
  IntroViewModel(this._ref) : super(IntroState());

  final Ref _ref;

  void updatePage(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> completeIntro() async {
    try {
      final pref = _ref.read(sharedRefProvider);
      await pref.setBool("hasSeenIntro", true);
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
