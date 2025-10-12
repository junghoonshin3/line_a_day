import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

class DiaryWriteState {
  bool isLoading = false;
  DiaryModel diary;
  String? errorMessage;

  DiaryWriteState({
    required this.diary,
    this.isLoading = false,
    this.errorMessage,
  });

  DiaryWriteState copyWith({
    DiaryModel? diary,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DiaryWriteState(
      diary: diary ?? this.diary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
