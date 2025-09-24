import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/model/diary_list_state.dart';
import 'package:line_a_day/service/diary_list_service.dart';

class DiaryListViewModel extends StateNotifier<DiaryListState> {
  final DiaryListService _service;

  DiaryListViewModel(this._service) : super(DiaryListState(diaryList: [])) {
    getDiaryList(DateTime.now());
  }

  void getDiaryList(DateTime dateTime) async {
    try {
      state = state.copyWith(isLoading: true);
      final diaryList = await _service.getDiaryItems(dateTime);
      state = state.copyWith(diaryList: diaryList, isLoading: false);
    } catch (e) {
      print("getDiaryList >>>> $e");
    }
  }

  void addDiary(DiaryEntity entity) async {
    try {
      state = state.copyWith(isLoading: true);
      await _service.addDiaryItem(entity);
      state = state.copyWith(
        diaryList: [...state.diaryList, entity],
        isLoading: false,
      );
    } catch (e) {
      print("addDiary >>>> $e");
    }
  }
}

final diaryListViewModelProvider =
    StateNotifierProvider<DiaryListViewModel, DiaryListState>((ref) {
      return DiaryListViewModel(ref.watch(diaryListServiceProvider));
    });
