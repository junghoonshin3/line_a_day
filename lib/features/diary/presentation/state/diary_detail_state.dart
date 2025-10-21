import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

class DiaryDetailState {
  final DiaryModel? diary;
  final bool isLoading;
  final bool isDeleting;
  final bool isDeleted;
  final String? errorMessage;

  const DiaryDetailState({
    this.diary,
    this.isLoading = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.errorMessage,
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
