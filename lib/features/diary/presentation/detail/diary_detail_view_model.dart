import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_detail_state.dart';

class DiaryDetailViewModel extends StateNotifier<DiaryDetailState> {
  final DiaryRepository _repository;
  final int diaryId;
  StreamSubscription<DiaryModel?>? _diarySubscription;

  DiaryDetailViewModel({
    required DiaryRepository repository,
    required this.diaryId,
  }) : _repository = repository,
       super(const DiaryDetailState()) {
    _loadDiary();
  }

  // 일기 불러오기
  void _loadDiary() {
    state = state.copyWith(isLoading: true);
    _diarySubscription = _repository
        .getDiaryById(diaryId)
        .listen(
          (model) {
            if (model != null) {
              state = state.copyWith(
                diary: model,
                isLoading: false,
                errorMessage: null,
              );
            } else {
              state = state.copyWith(
                isLoading: false,
                errorMessage: '일기를 찾을 수 없습니다.',
              );
            }
          },
          onError: (error, stackTrace) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: '일기를 불러오는데 실패했습니다.',
            );
          },
        );
  }

  // 일기 삭제
  Future<void> deleteDiary() async {
    if (state.diary == null) return;
    state = state.copyWith(isDeleting: true);
    try {
      await _repository.deleteDiary(state.diary!.id!);
      state = state.copyWith(isDeleting: false, isDeleted: true);
      _diarySubscription?.cancel();
    } catch (e) {
      state = state.copyWith(isDeleting: false, errorMessage: '일기 삭제에 실패했습니다.');
    }
  }

  // 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _diarySubscription?.cancel();
    super.dispose();
  }
}

// Provider - diaryId를 파라미터로 받음
final diaryDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<DiaryDetailViewModel, DiaryDetailState, int>((ref, diaryId) {
      final repository = ref.watch(diaryRepositoryProvider);
      return DiaryDetailViewModel(repository: repository, diaryId: diaryId);
    });
