import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/emoji/presentation/statistic/state/diary_statistic_state.dart';

class DiaryStatisticViewModel extends StateNotifier<DiaryStatisticState> {
  final DiaryRepository _repository;

  DiaryStatisticViewModel(this._repository) : super(DiaryStatisticState()) {
    _loadStatistics();
  }

  void _loadStatistics() async {
    state = state.copyWith(isLoading: true);

    DateTime startDate;
    DateTime endDate;

    // 현재 기간에 맞는 시작일, 종료일 계산
    switch (state.selectedPeriod) {
      case PeriodType.week:
        final monday = state.selectedDate.subtract(
          Duration(days: state.selectedDate.weekday - 1),
        );
        startDate = monday;
        endDate = monday.add(const Duration(days: 6));
        break;

      case PeriodType.month:
        startDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          1,
        );
        endDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month + 1,
          0,
        );
        break;

      case PeriodType.year:
        startDate = DateTime(state.selectedDate.year, 1, 1);
        endDate = DateTime(state.selectedDate.year, 12, 31);
        break;
    }

    // 변경: 전체 일기 대신, 기간 내 일기만 조회
    final diaries = await _repository.getDiariesByRange(startDate, endDate);

    if (diaries.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        totalDiaries: 0,
        emotionCounts: {},
        chartData: [],
      );
      return;
    }

    // 차트 생성 (이미 기간 필터링된 일기 기준)
    final chartData = _generateChartData(diaries);

    // 감정별 카운트 계산
    final Map<EmotionType, int> emotionCounts = {};
    for (final diary in diaries) {
      emotionCounts[diary.emotion] = (emotionCounts[diary.emotion] ?? 0) + 1;
    }

    // 최빈 감정
    EmotionType? mostFrequent;
    int maxCount = 0;
    emotionCounts.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = emotion;
      }
    });

    // 상태 업데이트
    state = state.copyWith(
      emotionCounts: emotionCounts,
      totalDiaries: diaries.length,
      mostFrequentEmotion: mostFrequent,
      chartData: chartData,
      isLoading: false,
      errorMessage: null,
    );
  }

  List<ChartDataPoint> _generateChartData(List<DiaryModel> diaries) {
    switch (state.selectedPeriod) {
      case PeriodType.week:
        return _generateWeeklyData(diaries);
      case PeriodType.month:
        return _generateMonthlyData(diaries);
      case PeriodType.year:
        return _generateYearlyData(diaries);
    }
  }

  /// 주간: 최근 7일 (월, 화, 수, 목, 금, 토, 일)
  List<ChartDataPoint> _generateWeeklyData(List<DiaryModel> diaries) {
    final now = state.selectedDate;
    final int weekday = now.weekday;
    final DateTime monday = now.subtract(Duration(days: weekday - 1));

    final weekData = <ChartDataPoint>[];

    // 월요일부터 일요일까지 순회
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));

      // 해당 날짜에 작성된 일기만 필터링
      final dayDiaries = diaries.where((d) {
        return d.createdAt.year == date.year &&
            d.createdAt.month == date.month &&
            d.createdAt.day == date.day;
      }).toList();

      // 가장 많이 사용된 감정 찾기
      EmotionType? dominantEmotion;
      int maxCount = 0;

      if (dayDiaries.isNotEmpty) {
        final Map<EmotionType, int> dayEmotions = {};
        for (final diary in dayDiaries) {
          dayEmotions[diary.emotion] = (dayEmotions[diary.emotion] ?? 0) + 1;
        }

        dayEmotions.forEach((emotion, count) {
          if (count > maxCount) {
            maxCount = count;
            dominantEmotion = emotion;
          }
        });
      }

      // 요일명 (월, 화, 수, ...)
      final dayLabel = DateFormat('E', 'ko').format(date);

      weekData.add(
        ChartDataPoint(
          label: dayLabel,
          emotion: dominantEmotion ?? EmotionType.calm,
          count: dayDiaries.length,
          date: date,
        ),
      );
    }

    return weekData;
  }

  /// 월간: 해당 월의 주차별 (1주, 2주, 3주, 4주, 5주)
  List<ChartDataPoint> _generateMonthlyData(List<DiaryModel> diaries) {
    final selectedMonth = state.selectedDate;
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    final monthData = <ChartDataPoint>[];

    // 주차별로 묶기
    int weekNum = 1;
    DateTime weekStart = firstDay;

    while (weekStart.isBefore(lastDay) || weekStart.isAtSameMomentAs(lastDay)) {
      DateTime weekEnd = weekStart.add(const Duration(days: 6));
      if (weekEnd.isAfter(lastDay)) weekEnd = lastDay;

      final weekDiaries = diaries.where((d) {
        return d.createdAt.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            ) &&
            d.createdAt.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      // 가장 많이 사용된 감정
      EmotionType? dominantEmotion;
      int maxCount = 0;

      if (weekDiaries.isNotEmpty) {
        final Map<EmotionType, int> weekEmotions = {};
        for (final diary in weekDiaries) {
          weekEmotions[diary.emotion] = (weekEmotions[diary.emotion] ?? 0) + 1;
        }

        weekEmotions.forEach((emotion, count) {
          if (count > maxCount) {
            maxCount = count;
            dominantEmotion = emotion;
          }
        });
      }

      monthData.add(
        ChartDataPoint(
          label: '$weekNum주',
          emotion: dominantEmotion ?? EmotionType.calm,
          count: weekDiaries.length,
          date: weekStart,
        ),
      );

      weekStart = weekEnd.add(const Duration(days: 1));
      weekNum++;
    }

    return monthData;
  }

  /// 연간: 12개월 (1월, 2월, 3월 ... 12월)
  List<ChartDataPoint> _generateYearlyData(List<DiaryModel> diaries) {
    final selectedYear = state.selectedDate.year;
    final yearData = <ChartDataPoint>[];

    for (int month = 1; month <= 12; month++) {
      final monthDiaries = diaries.where((d) {
        return d.createdAt.year == selectedYear && d.createdAt.month == month;
      }).toList();

      // 가장 많이 사용된 감정
      EmotionType? dominantEmotion;
      int maxCount = 0;

      if (monthDiaries.isNotEmpty) {
        final Map<EmotionType, int> monthEmotions = {};
        for (final diary in monthDiaries) {
          monthEmotions[diary.emotion] =
              (monthEmotions[diary.emotion] ?? 0) + 1;
        }

        monthEmotions.forEach((emotion, count) {
          if (count > maxCount) {
            maxCount = count;
            dominantEmotion = emotion;
          }
        });
      }

      yearData.add(
        ChartDataPoint(
          label: '$month월',
          emotion: dominantEmotion ?? EmotionType.calm,
          count: monthDiaries.length,
          date: DateTime(selectedYear, month),
        ),
      );
    }

    return yearData;
  }

  void changePeriod(PeriodType period) {
    state = state.copyWith(selectedPeriod: period);
    _loadStatistics(); // 차트 데이터 재생성
  }

  void changeDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    _loadStatistics(); // 차트 데이터 재생성
  }

  // 날짜 이동
  void goToPreviousPeriod() {
    DateTime newDate;
    switch (state.selectedPeriod) {
      case PeriodType.week:
        final monday = state.selectedDate.subtract(
          Duration(days: state.selectedDate.weekday - 1),
        );
        newDate = monday.subtract(const Duration(days: 7));
        break;
      case PeriodType.month:
        newDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month - 1,
          1,
        );
        break;

      case PeriodType.year:
        newDate = DateTime(state.selectedDate.year - 1, 1, 1);
        break;
    }
    changeDate(newDate);
  }

  void goToNextPeriod() {
    DateTime newDate;

    switch (state.selectedPeriod) {
      case PeriodType.week:
        // 현재 주의 월요일을 기준으로 한 주 후로 이동
        final monday = state.selectedDate.subtract(
          Duration(days: state.selectedDate.weekday - 1),
        );
        newDate = monday.add(const Duration(days: 7));
        break;

      case PeriodType.month:
        newDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month + 1,
          1,
        );
        break;

      case PeriodType.year:
        newDate = DateTime(state.selectedDate.year + 1, 1, 1);
        break;
    }
    changeDate(newDate);
  }

  List<EmotionStatItem> getEmotionStats() {
    if (state.totalDiaries == 0) return [];

    final items = <EmotionStatItem>[];
    state.emotionCounts.forEach((type, count) {
      items.add(
        EmotionStatItem(
          type: type,
          count: count,
          percentage: (count / state.totalDiaries) * 100,
        ),
      );
    });

    items.sort((a, b) => b.count.compareTo(a.count));
    return items;
  }
}

final emojiStatisticViewModelProvider =
    StateNotifierProvider.autoDispose<
      DiaryStatisticViewModel,
      DiaryStatisticState
    >((ref) {
      final repository = ref.watch(diaryRepositoryProvider);
      return DiaryStatisticViewModel(repository);
    });
