import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/model/diary_write_state.dart';
import 'package:line_a_day/service/diary_list_service.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  final DiaryListService _serivce;

  DiaryWriteViewModel(this._serivce) : super(DiaryWriteState());

  void onChangedText(String text) {
    state = state.copyWith(text: text);
  }

  void onChangedTitle(String title) {
    state = state.copyWith(title: title);
  }

  void onChangedPrompt(String text) {
    state = state.copyWith(currentPrompt: text);
  }

  void setWritingState(bool isWriting) {
    state = state.copyWith(isWriting: isWriting);
  }

  void setEmojiShowing(bool isEmojiShwing) {
    state = state.copyWith(emojiShowing: isEmojiShwing);
  }

  void saveDiary(DiaryEntity diary) {
    _serivce.addDiaryItem(diary);
  }
}

final diaryWriteViewModelProvider =
    StateNotifierProvider.autoDispose<DiaryWriteViewModel, DiaryWriteState>((
      ref,
    ) {
      return DiaryWriteViewModel(ref.watch(diaryListServiceProvider));
    });
