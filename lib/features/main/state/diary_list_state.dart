import 'package:line_a_day/constant.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/model/mood.dart';

class DiaryListState {
  final List<DiaryEntity> entries;
  final DateTime selectedDate;
  final DateTime focusedDate;
  final MoodType? filterMood;
  final bool isLoading;
  final String? errorMessage;
  final DiaryListStats stats;

  DiaryListState({
    this.entries = const [],
    DateTime? selectedDate,
    DateTime? focusedDate,
    this.filterMood,
    this.isLoading = false,
    this.errorMessage,
    DiaryListStats? stats,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       focusedDate = focusedDate ?? DateTime.now(),
       stats = stats ?? const DiaryListStats();

  DiaryListState copyWith({
    List<DiaryEntity>? entries,
    DateTime? selectedDate,
    DateTime? focusedDate,
    MoodType? filterMood,
    bool? clearFilter,
    bool? isLoading,
    String? errorMessage,
    DiaryListStats? stats,
  }) {
    return DiaryListState(
      entries: entries ?? this.entries,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      filterMood: clearFilter == true ? null : (filterMood ?? this.filterMood),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
    );
  }
}

class DiaryListStats {
  final int totalEntries;
  final int currentStreak;
  final String recentMood;

  const DiaryListStats({
    this.totalEntries = 0,
    this.currentStreak = 0,
    this.recentMood = '😊',
  });
}
