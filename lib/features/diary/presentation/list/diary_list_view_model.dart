import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_list_state.dart';

class DiaryListViewModel extends StateNotifier<DiaryListState> {
  DiaryListViewModel() : super(DiaryListState()) {
    loadEntries();
  }

  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Isar에서 일기 로드
      await Future.delayed(const Duration(milliseconds: 500));

      final entries = _generateMockData();
      final stats = _calculateStats(entries);

      state = state.copyWith(entries: entries, stats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '일기를 불러오는데 실패했습니다.',
      );
    }
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }

  void filterByMood(MoodType? mood) {
    state = state.copyWith(filterMood: mood, clearFilter: mood == null);
  }

  List<DiaryModel> getFilteredEntries() {
    var filtered = state.entries;

    if (state.filterMood != null) {
      filtered = filtered
          .where((entry) => entry.mood == state.filterMood)
          .toList();
    }

    return filtered;
  }

  List<DiaryModel> getEntriesForDate(DateTime date) {
    return state.entries.where((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    }).toList();
  }

  bool hasEntryOnDate(DateTime date) {
    return state.entries.any((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    });
  }

  Map<String, List<DiaryModel>> getGroupedEntries() {
    final filtered = getFilteredEntries();
    final Map<String, List<DiaryModel>> grouped = {};

    for (final entry in filtered) {
      final dateKey = DateFormat().format(entry.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(entry);
    }

    return grouped;
  }

  DiaryListStats _calculateStats(List<DiaryModel> entries) {
    if (entries.isEmpty) {
      return const DiaryListStats();
    }

    final sortedEntries = entries.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DiaryListStats(
      totalEntries: entries.length,
      currentStreak: _calculateStreak(sortedEntries),
      recentMood: Mood.getMoodByType(sortedEntries.first.mood)?.emoji ?? '😊',
    );
  }

  int _calculateStreak(List<DiaryModel> sortedEntries) {
    if (sortedEntries.isEmpty) return 0;

    int streak = 1;
    DateTime lastDate = sortedEntries.first.createdAt;

    for (int i = 1; i < sortedEntries.length; i++) {
      final currentDate = sortedEntries[i].createdAt;
      final daysDiff = lastDate.difference(currentDate).inDays;

      if (daysDiff == 1) {
        streak++;
        lastDate = currentDate;
      } else {
        break;
      }
    }

    return streak;
  }

  List<DiaryModel> _generateMockData() {
    final now = DateTime.now();
    return [
      DiaryModel(
        id: 1,
        createdAt: now,
        title: '오랜만에 친구들과 만난 날',
        content:
            '오늘은 대학 동기들과 오랜만에 만나서 저녁을 먹었다. 다들 바쁘게 살다보니 이렇게 모이기가 쉽지 않은데, 오늘 정말 즐거웠다...',
        mood: MoodType.happy,
        tags: ['친구', '행복'],
        weather: '☀️ 맑음',
        location: '강남역',
      ),
      DiaryModel(
        id: 2,
        createdAt: now.subtract(const Duration(days: 1)),
        title: '프로젝트 마감',
        content:
            '드디어 한 달간 작업하던 프로젝트가 마무리되었다. 힘들었지만 보람찬 시간이었고, 많은 것을 배울 수 있었다...',
        mood: MoodType.calm,
        tags: ['업무', '성취감'],
        weather: '🌧️ 비',
      ),
      DiaryModel(
        id: 3,
        createdAt: now.subtract(const Duration(days: 2)),
        title: '평범한 월요일',
        content:
            '월요일은 언제나 피곤하다. 오늘은 특별한 일 없이 평범하게 하루를 보냈다. 저녁에는 넷플릭스를 보며 쉬었다...',
        mood: MoodType.tired,
        tags: ['일상', '휴식'],
        weather: '☁️ 흐림',
      ),
    ];
  }
}

final diaryListViewModelProvider =
    StateNotifierProvider<DiaryListViewModel, DiaryListState>(
      (ref) => DiaryListViewModel(),
    );
