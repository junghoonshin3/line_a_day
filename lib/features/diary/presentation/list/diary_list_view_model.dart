import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_list_state.dart';

class DiaryListViewModel extends StateNotifier<DiaryListState> {
  final DiaryRepository _repository;
  StreamSubscription<List<DiaryModel>>? _diariesSubscription;

  // 전체 일기 데이터를 메모리에 캐싱
  List<DiaryModel> _allDiaries = [];

  DiaryListViewModel(this._repository) : super(DiaryListState()) {
    _initializeDiaryStream();
  }

  // Stream 초기화 - DB의 모든 변경사항을 실시간으로 감지
  void _initializeDiaryStream() {
    state = state.copyWith(isLoading: true);

    _diariesSubscription = _repository.getAllDiaries().listen(
      (allDiaries) {
        // 전체 데이터 캐싱
        _allDiaries = allDiaries;

        // 통계 계산 (전체 데이터 기준)
        final stats = _calculateStats(allDiaries);

        // 현재 선택된 날짜와 필터에 맞는 일기만 추출
        final filteredEntries = _getFilteredAndDateFilteredEntries();

        state = state.copyWith(
          entries: filteredEntries, // 화면에 표시될 일기 목록
          stats: stats, // 전체 통계 (실시간 업데이트)
          isLoading: false,
          errorMessage: null,
        );
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '일기를 불러오는데 실패했습니다.',
        );
        print('일기 스트림 에러: $error');
      },
    );
  }

  // 날짜 선택 - 선택한 날짜가 변경되면 해당 날짜의 일기만 필터링
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    // 날짜가 변경되었으므로 필터링된 목록 다시 계산
    _updateFilteredEntries();
  }

  // 포커스된 날짜 설정 (캘린더 페이지 변경용)
  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }

  // 감정별 필터링
  void filterByMood(EmotionType? mood) {
    state = state.copyWith(filterMood: mood, clearFilter: mood == null);
    // 필터가 변경되었으므로 필터링된 목록 다시 계산
    _updateFilteredEntries();
  }

  // 필터링된 일기 목록 업데이트 (날짜 + 감정 필터 적용)
  void _updateFilteredEntries() {
    final filteredEntries = _getFilteredAndDateFilteredEntries();
    state = state.copyWith(entries: filteredEntries);
  }

  // 날짜와 감정 필터를 모두 적용한 일기 목록 반환
  List<DiaryModel> _getFilteredAndDateFilteredEntries() {
    var filtered = _allDiaries;

    // 선택된 날짜가 있으면 해당 날짜의 일기만 필터링
    final selectedDate = state.selectedDate;
    filtered = filtered.where((entry) {
      return entry.createdAt.year == selectedDate.year &&
          entry.createdAt.month == selectedDate.month &&
          entry.createdAt.day == selectedDate.day;
    }).toList();

    // 감정 필터 적용
    if (state.filterMood != null) {
      filtered = filtered
          .where((entry) => entry.emotion == state.filterMood)
          .toList();
    }

    return filtered;
  }

  // 일기 삭제 - Stream이 자동으로 업데이트
  Future<void> deleteDiary(int id) async {
    try {
      await _repository.deleteDiary(id);
    } catch (e) {
      state = state.copyWith(errorMessage: '일기 삭제에 실패했습니다.');
      rethrow;
    }
  }

  // 일기 추가/수정 후 호출 (필요시)
  // Future<void> refreshData() async {
  //   // Stream이 자동으로 업데이트하므로 실제로는 불필요
  //   // 하지만 명시적으로 새로고침이 필요한 경우 사용
  // }

  // 특정 날짜의 일기 목록 가져오기
  List<DiaryModel> getEntriesForDate(DateTime date) {
    return _allDiaries.where((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    }).toList();
  }

  // 특정 날짜에 일기가 있는지 확인 (캘린더 마커용)
  bool hasEntryOnDate(DateTime date) {
    return _allDiaries.any((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    });
  }

  // 날짜별로 그룹화된 일기 목록 (현재 화면에 표시된 entries 사용)
  Map<String, List<DiaryModel>> getGroupedEntries() {
    final filtered = state.entries; // 이미 필터링된 entries 사용
    final Map<String, List<DiaryModel>> grouped = {};

    for (final entry in filtered) {
      final dateKey = DateFormat(
        'yyyy년 MM월 dd일 E',
        'ko',
      ).format(entry.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(entry);
    }

    // 날짜별로 정렬 (최신순)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  // 통계 계산 (전체 일기 기준)
  DiaryListStats _calculateStats(List<DiaryModel> entries) {
    if (entries.isEmpty) {
      return const DiaryListStats();
    }

    final sortedEntries = entries.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DiaryListStats(
      totalEntries: entries.length,
      currentStreak: _calculateStreak(sortedEntries),
      recentEmotion: sortedEntries.first.emotion,
    );
  }

  // 연속 작성일 계산
  int _calculateStreak(List<DiaryModel> sortedEntries) {
    if (sortedEntries.isEmpty) return 0;

    int streak = 1;
    DateTime lastDate = DateTime(
      sortedEntries.first.createdAt.year,
      sortedEntries.first.createdAt.month,
      sortedEntries.first.createdAt.day,
    );

    for (int i = 1; i < sortedEntries.length; i++) {
      final currentDate = DateTime(
        sortedEntries[i].createdAt.year,
        sortedEntries[i].createdAt.month,
        sortedEntries[i].createdAt.day,
      );
      final daysDiff = lastDate.difference(currentDate).inDays;

      if (daysDiff == 1) {
        streak++;
        lastDate = currentDate;
      } else if (daysDiff > 1) {
        break;
      }
    }

    return streak;
  }

  // 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _diariesSubscription?.cancel();
    super.dispose();
  }
}

// Provider 설정
final diaryListViewModelProvider =
    StateNotifierProvider<DiaryListViewModel, DiaryListState>((ref) {
      final repository = ref.watch(diaryRepositoryProvider);
      return DiaryListViewModel(repository);
    });
