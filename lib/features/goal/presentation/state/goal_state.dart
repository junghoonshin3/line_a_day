import 'package:line_a_day/features/goal/domain/model/goal_model.dart';

class GoalState {
  final List<GoalModel> activeGoals;
  final List<GoalModel> completedGoals;
  final List<Badge> unlockedBadges;
  final int totalDiaries;
  final int currentStreak;
  final int longestStreak;
  final double positiveEmotionRate;
  final bool isLoading;
  final String? errorMessage;

  GoalState({
    this.activeGoals = const [],
    this.completedGoals = const [],
    this.unlockedBadges = const [],
    this.totalDiaries = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.positiveEmotionRate = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  GoalState copyWith({
    List<GoalModel>? activeGoals,
    List<GoalModel>? completedGoals,
    List<Badge>? unlockedBadges,
    int? totalDiaries,
    int? currentStreak,
    int? longestStreak,
    double? positiveEmotionRate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GoalState(
      activeGoals: activeGoals ?? this.activeGoals,
      completedGoals: completedGoals ?? this.completedGoals,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      totalDiaries: totalDiaries ?? this.totalDiaries,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      positiveEmotionRate: positiveEmotionRate ?? this.positiveEmotionRate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
