enum GoalType {
  weeklyDiary, // 주간 일기 작성 목표
  monthlyDiary, // 월간 일기 작성 목표
  streak, // 연속 작성 목표
  positiveEmotion, // 긍정 감정 비율
  custom, // 커스텀 목표
}

enum GoalStatus { inProgress, completed, failed }

class GoalModel {
  final String id;
  final GoalType type;
  final String title;
  final String description;
  final int targetValue; // 목표 값
  final int currentValue; // 현재 값
  final DateTime startDate;
  final DateTime endDate;
  final GoalStatus status;
  final String? emoji;
  final int colorCode;

  GoalModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.emoji,
    required this.colorCode,
  });

  double get progress {
    if (targetValue == 0) return 0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  bool get isCompleted => currentValue >= targetValue;

  int get remainingDays {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  GoalModel copyWith({
    String? id,
    GoalType? type,
    String? title,
    String? description,
    int? targetValue,
    int? currentValue,
    DateTime? startDate,
    DateTime? endDate,
    GoalStatus? status,
    String? emoji,
    int? colorCode,
  }) {
    return GoalModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      emoji: emoji ?? this.emoji,
      colorCode: colorCode ?? this.colorCode,
    );
  }
}

class Badge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int colorCode;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.colorCode,
    required this.isUnlocked,
    this.unlockedAt,
  });

  static const List<Badge> allBadges = [
    Badge(
      id: 'first_diary',
      title: '첫 발걸음',
      description: '첫 일기를 작성했어요',
      emoji: '👶',
      colorCode: 0xFFFEF3C7,
      isUnlocked: false,
    ),
    Badge(
      id: 'week_streak',
      title: '일주일의 기록',
      description: '7일 연속 일기 작성',
      emoji: '🔥',
      colorCode: 0xFFFED7AA,
      isUnlocked: false,
    ),
    Badge(
      id: 'month_streak',
      title: '한 달의 여정',
      description: '30일 연속 일기 작성',
      emoji: '⭐',
      colorCode: 0xFFFDE68A,
      isUnlocked: false,
    ),
    Badge(
      id: 'hundred_diaries',
      title: '백일장',
      description: '총 100개의 일기 작성',
      emoji: '💯',
      colorCode: 0xFFDBEAFE,
      isUnlocked: false,
    ),
    Badge(
      id: 'happy_week',
      title: '행복한 주',
      description: '일주일 동안 긍정 감정만 기록',
      emoji: '😊',
      colorCode: 0xFFFCE7F3,
      isUnlocked: false,
    ),
    Badge(
      id: 'growth_mindset',
      title: '성장 마인드',
      description: '한 달간 목표 5개 달성',
      emoji: '🌱',
      colorCode: 0xFFD1FAE5,
      isUnlocked: false,
    ),
  ];
}
