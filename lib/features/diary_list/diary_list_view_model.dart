import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_list_state.dart';

class DiaryListViewModel extends StateNotifier<DiaryListState> {
  DiaryListViewModel() : super(DiaryListState());
}

final diaryListViewModelProvider =
    StateNotifierProvider<DiaryListViewModel, DiaryListState>((ref) {
      return DiaryListViewModel();
    });
