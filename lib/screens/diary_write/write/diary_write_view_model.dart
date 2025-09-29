import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_write_state.dart';
import 'package:line_a_day/service/diary_list_service.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  final DiaryListService _serivce;

  DiaryWriteViewModel(this._serivce) : super(DiaryWriteState());

  void saveDraft() async {
    state = state.copyWith(isLoading: true);

    try {} catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }

    // 임시저장 로직
    // await Future.delayed(const Duration(milliseconds: 500));
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
    StateNotifierProvider.autoDispose<DiaryWriteViewModel, DiaryWriteState>((
      ref,
    ) {
      return DiaryWriteViewModel(ref.read(diaryListServiceProvider));
    });
