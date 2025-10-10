import 'package:line_a_day/constant.dart';

class DiaryMoodState {
  final MoodType? selectedMood;
  final bool isLoading;
  final String? errorMessage;
  final bool isCompleted;

  DiaryMoodState({
    this.selectedMood,
    this.isLoading = false,
    this.errorMessage,
    this.isCompleted = false,
  });

  DiaryMoodState copyWith({
    MoodType? selectedMood,
    bool? isLoading,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return DiaryMoodState(
      selectedMood: selectedMood ?? this.selectedMood,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
