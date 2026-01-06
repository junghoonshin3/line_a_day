import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';

class DiaryListState extends BaseState {
  final List<DiaryModel> entries;
  final DateTime selectedDate;
  final DateTime focusedDate;
  final EmotionType? filterMood;
  final DiaryListStats stats;
  final bool isSearchMode;
  final String searchQuery;
  final List<DiaryModel> searchResults;
  final bool isCalendarExpanded;

  DiaryListState({
    this.entries = const [],
    DateTime? selectedDate,
    DateTime? focusedDate,
    this.filterMood,
    super.isLoading = false,
    super.errorMessage,
    DiaryListStats? stats,
    this.isSearchMode = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isCalendarExpanded = true,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       focusedDate = focusedDate ?? DateTime.now(),
       stats = stats ?? const DiaryListStats();

  DiaryListState copyWith({
    List<DiaryModel>? entries,
    DateTime? selectedDate,
    DateTime? focusedDate,
    EmotionType? filterMood,
    bool? clearFilter,
    bool? isLoading,
    String? errorMessage,
    DiaryListStats? stats,
    bool? isSearchMode,
    String? searchQuery,
    List<DiaryModel>? searchResults,
    bool? isCalendarExpanded,
  }) {
    return DiaryListState(
      entries: entries ?? this.entries,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      filterMood: clearFilter == true ? null : (filterMood ?? this.filterMood),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isCalendarExpanded: isCalendarExpanded ?? this.isCalendarExpanded,
    );
  }
}

class DiaryListStats {
  final int totalEntries;
  final int currentStreak;
  final EmotionType recentEmotion;

  const DiaryListStats({
    this.totalEntries = 0,
    this.currentStreak = 0,
    this.recentEmotion = EmotionType.calm,
  });
}
