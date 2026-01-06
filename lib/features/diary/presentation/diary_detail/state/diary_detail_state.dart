import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';

class DiaryDetailState extends BaseState {
  final DiaryModel? diary;
  final bool isDeleting;
  final bool isDeleted;

  const DiaryDetailState({
    this.diary,
    super.isLoading = false,
    this.isDeleting = false,
    this.isDeleted = false,
    super.errorMessage,
  });

  DiaryDetailState copyWith({
    DiaryModel? diary,
    bool? isLoading,
    bool? isDeleting,
    bool? isDeleted,
    String? errorMessage,
  }) {
    return DiaryDetailState(
      diary: diary ?? this.diary,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: errorMessage,
    );
  }
}
