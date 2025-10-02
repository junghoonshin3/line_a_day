import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_write_state.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  DiaryWriteViewModel() : super(DiaryWriteState());

  void saveDraft() async {
    state = state.copyWith(isLoading: true);

    try {} catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void saveEntry() async {
    state = state.copyWith(isLoading: true);
    try {} catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final diaryWriteViewModelProvider =
    StateNotifierProvider<DiaryWriteViewModel, DiaryWriteState>((ref) {
      return DiaryWriteViewModel();
    });
