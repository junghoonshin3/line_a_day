import 'package:line_a_day/constant.dart';

class DiaryEmotionState {
  final EmotionType? selectedEmotion;
  final bool isLoading;
  final String? errorMessage;
  final bool isCompleted;

  DiaryEmotionState({
    this.selectedEmotion,
    this.isLoading = false,
    this.errorMessage,
    this.isCompleted = false,
  });

  DiaryEmotionState copyWith({
    EmotionType? selectedEmotion,
    bool? isLoading,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return DiaryEmotionState(
      selectedEmotion: selectedEmotion ?? this.selectedEmotion,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
