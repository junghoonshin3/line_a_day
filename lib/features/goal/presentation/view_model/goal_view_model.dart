import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/goal/domain/model/goal_model.dart';
import 'package:line_a_day/features/goal/presentation/state/goal_state.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';

class GoalViewModel extends StateNotifier<GoalState> {
  final DiaryRepository _repository;

  GoalViewModel(this._repository) : super(GoalState()) {
    _loadGoals();
  }

  void _loadGoals() async {
    state = state.copyWith(isLoading: true);

    // 실제 일기 데이터를 기반으로 통계 계산
    final diaries = await _repository.getAllDiaries();
    final totalDiaries = diaries.length;

    // 연속 작성일 계산
    final sortedDiaries = diaries
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final (currentStreak, longestStreak) = _calculateStreaks(sortedDiaries);

    // if (sortedDiaries.isNotEmpty) {
    //   currentStreak = 1;
    //   tempStreak = 1;
    //   DateTime lastDate = DateTime(
    //     sortedDiaries.first.createdAt.year,
    //     sortedDiaries.first.createdAt.month,
    //     sortedDiaries.first.createdAt.day,
    //   );

    //   for (int i = 1; i < sortedDiaries.length; i++) {
    //     final currentDate = DateTime(
    //       sortedDiaries[i].createdAt.year,
    //       sortedDiaries[i].createdAt.month,
    //       sortedDiaries[i].createdAt.day,
    //     );
    //     final daysDiff = lastDate.difference(currentDate).inDays;

    //     if (daysDiff == 1) {
    //       if (i == 1) currentStreak++;
    //       tempStreak++;
    //       if (tempStreak > longestStreak) longestStreak = tempStreak;
    //     } else if (daysDiff > 1) {
    //       if (tempStreak > longestStreak) longestStreak = tempStreak;
    //       tempStreak = 1;
    //     }
    //     lastDate = currentDate;
    //   }
    //   if (tempStreak > longestStreak) longestStreak = tempStreak;
    // }

    // 긍정 감정 비율 계산
    final positiveEmotions = [
      EmotionType.happy,
      EmotionType.excited,
      EmotionType.grateful,
      EmotionType.proud,
      EmotionType.hopeful,
    ];

    final positiveCount = diaries
        .where((d) => positiveEmotions.contains(d.emotion))
        .length;
    final positiveRate = totalDiaries > 0
        ? (positiveCount / totalDiaries) * 100
        : 0.0;

    // 목표 생성/업데이트
    final activeGoals = _generateGoals(
      diaries,
      totalDiaries,
      currentStreak,
      positiveRate,
    );

    // 뱃지 확인
    final unlockedBadges = _checkBadges(
      totalDiaries,
      currentStreak,
      longestStreak,
    );

    state = state.copyWith(
      activeGoals: activeGoals,
      totalDiaries: totalDiaries,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      positiveEmotionRate: positiveRate,
      unlockedBadges: unlockedBadges,
      isLoading: false,
    );
  }

  (int currentStreak, int longestStreak) _calculateStreaks(
    List<DiaryModel> sortedDiaries,
  ) {
    if (sortedDiaries.isEmpty) return (0, 0);

    // 날짜만 비교하기 위해 시/분/초를 제거한 DateTime 리스트 생성 (중복일 제거)
    final dates = <DateTime>[];
    for (final d in sortedDiaries) {
      final day = DateTime(
        d.createdAt.year,
        d.createdAt.month,
        d.createdAt.day,
      );
      if (dates.isEmpty || dates.last.compareTo(day) != 0) {
        // sortedDiaries가 최신순이므로 dates.last는 바로 이전(더 최신) 날짜
        dates.add(day);
      }
    }

    // longestStreak 계산 (연속되는 구간의 최대 길이)
    int longest = 1;
    int temp = 1;
    for (int i = 1; i < dates.length; i++) {
      final prev = dates[i - 1]; // 더 최신
      final cur = dates[i]; // 이전 날짜(더 과거)
      final diff = prev.difference(cur).inDays;

      if (diff == 1) {
        temp++;
      } else {
        if (temp > longest) longest = temp;
        temp = 1;
      }
    }
    if (temp > longest) longest = temp;

    // currentStreak 계산: 가장 최신 날짜가 오늘 또는 어제여야 시작,
    // 중간에 끊기면 즉시 멈추고 현재 streak 확정.
    final today = DateTime.now();
    final latest = dates.first; // 가장 최근(최신) 날짜
    final daysSinceLatest = today.difference(latest).inDays;

    int current = 0;
    if (daysSinceLatest <= 1) {
      // 최신이 오늘 또는 어제이므로 streak가 존재할 수 있음
      current = 1;
      for (int i = 1; i < dates.length; i++) {
        final prev = dates[i - 1];
        final cur = dates[i];
        final diff = prev.difference(cur).inDays;
        if (diff == 1) {
          current++;
        } else {
          break; // 중간에 끊기면 현재 streak는 여기서 끝
        }
      }
    } else {
      // 최신이 어제보다 이전이면 현재 streak는 0으로 리셋되어야 함
      current = 0;
    }

    return (current, longest);
  }

  List<GoalModel> _generateGoals(
    List<DiaryModel> diarires,
    int totalDiaries,
    int currentStreak,
    double positiveRate,
  ) {
    final now = DateTime.now();
    final goals = <GoalModel>[];

    // 주간 목표 (이번 주 5일 작성)
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    goals.add(
      GoalModel(
        id: 'weekly_diary',
        type: GoalType.weeklyDiary,
        title: '이번 주 일기 작성',
        description: '이번 주에 5일 이상 일기를 작성해보세요',
        targetValue: 5,
        currentValue: _getWeekDiaryCount(diarires),
        startDate: weekStart,
        endDate: weekEnd,
        status: GoalStatus.inProgress,
        emoji: '📝',
        colorCode: 0xFF3B82F6,
      ),
    );

    // 연속 작성 목표
    goals.add(
      GoalModel(
        id: 'streak_7',
        type: GoalType.streak,
        title: '7일 연속 작성',
        description: '일주일 동안 매일 일기를 작성해보세요',
        targetValue: 7,
        currentValue: currentStreak,
        startDate: now,
        endDate: now.add(const Duration(days: 7)),
        status: GoalStatus.inProgress,
        emoji: '🔥',
        colorCode: 0xFFFB923C,
      ),
    );

    // 긍정 감정 목표
    goals.add(
      GoalModel(
        id: 'positive_emotion',
        type: GoalType.positiveEmotion,
        title: '긍정적인 마음가짐',
        description: '긍정 감정 비율 70% 달성하기',
        targetValue: 70,
        currentValue: positiveRate.toInt(),
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
        status: GoalStatus.inProgress,
        emoji: '😊',
        colorCode: 0xFFFCD34D,
      ),
    );

    // 월간 목표
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    goals.add(
      GoalModel(
        id: 'monthly_diary',
        type: GoalType.monthlyDiary,
        title: '이번 달 목표',
        description: '이번 달에 20일 이상 일기 작성하기',
        targetValue: 20,
        currentValue: _getMonthDiaryCount(diarires),
        startDate: monthStart,
        endDate: monthEnd,
        status: GoalStatus.inProgress,
        emoji: '🎯',
        colorCode: 0xFF8B5CF6,
      ),
    );

    return goals;
  }

  int _getWeekDiaryCount(List<DiaryModel> diaries) {
    final now = DateTime.now();

    // 이번 주 월요일 00:00:00
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );
    final weekEnd = weekStart.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    // 이번 주 날짜 범위 내에 작성된 일기들의 "날짜"만 추출
    final Set<DateTime> uniqueDays = {};
    for (final diary in diaries) {
      final date = DateTime(
        diary.createdAt.year,
        diary.createdAt.month,
        diary.createdAt.day,
      );
      if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) {
        uniqueDays.add(date);
      }
    }

    // 이번 주에 일기를 작성한 "날짜 수"
    return uniqueDays.length;
  }

  int _getMonthDiaryCount(List<DiaryModel> diaries) {
    final now = DateTime.now();

    // 이번 달의 1일 00:00:00 ~ 마지막 날 23:59:59
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // 이번 달 날짜 범위 내에 작성된 일기들의 "날짜"만 추출
    final Set<DateTime> uniqueDays = {};
    for (final diary in diaries) {
      final date = DateTime(
        diary.createdAt.year,
        diary.createdAt.month,
        diary.createdAt.day,
      );
      if (!date.isBefore(monthStart) && !date.isAfter(monthEnd)) {
        uniqueDays.add(date);
      }
    }

    // 이번 달에 일기를 작성한 "날짜 수"
    return uniqueDays.length;
  }

  List<Badge> _checkBadges(
    int totalDiaries,
    int currentStreak,
    int longestStreak,
  ) {
    final unlockedBadges = <Badge>[];

    // 첫 일기
    if (totalDiaries >= 1) {
      unlockedBadges.add(Badge.allBadges[0]);
    }

    // 7일 연속
    if (longestStreak >= 7) {
      unlockedBadges.add(Badge.allBadges[1]);
    }

    // 30일 연속
    if (longestStreak >= 30) {
      unlockedBadges.add(Badge.allBadges[2]);
    }

    // 100개 일기
    if (totalDiaries >= 100) {
      unlockedBadges.add(Badge.allBadges[3]);
    }

    return unlockedBadges;
  }

  void completeGoal(String goalId) {
    final goals = state.activeGoals.map((goal) {
      if (goal.id == goalId) {
        return goal.copyWith(status: GoalStatus.completed);
      }
      return goal;
    }).toList();

    state = state.copyWith(activeGoals: goals);
  }
}

final goalViewModelProvider =
    StateNotifierProvider.autoDispose<GoalViewModel, GoalState>((ref) {
      final repository = ref.watch(diaryRepositoryProvider);
      return GoalViewModel(repository);
    });
