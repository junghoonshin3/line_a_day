import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/domain/repository/draft_repository.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_write_state.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  DiaryWriteViewModel({
    required this.diary,
    required this.draftRepository,
    required this.diaryRepository,
  }) : super(DiaryWriteState(diary: diary));
  final DiaryModel diary;
  final DraftRepository draftRepository;
  final DiaryRepository diaryRepository;

  void checkDraft() {
    final hasDraft = draftRepository.hasDraft();
    if (hasDraft) {
      final draft = draftRepository.loadDraft();
      print("darft : ${draft.title}");
      state = state.copyWith(diary: draft);
    }
  }

  void saveDraft(DiaryModel model) async {
    state = state.copyWith(isLoading: true);
    try {
      await draftRepository.saveDraft(model);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void saveDiary(DiaryModel diary) async {
    state = state.copyWith(isLoading: true);
    try {
      await diaryRepository.saveDiary(diary);
    } catch (e) {
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
      final viewModel = DiaryWriteViewModel(
        diary: DiaryModel(
          createdAt: DateTime.now(),
          title: "",
          content: "",
          mood: MoodType.calm,
        ),
        draftRepository: ref.watch(draftRepositoryProvider),
        diaryRepository: ref.watch(diaryRepositoryProvider),
      );

      viewModel.checkDraft();

      return viewModel;
    });
