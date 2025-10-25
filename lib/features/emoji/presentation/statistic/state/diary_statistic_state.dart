import 'package:line_a_day/constant.dart';

class DiaryStatisticState {
  final Map<EmotionType, int> emotionCounts;
  final int totalDiaries;
  final EmotionType? mostFrequentEmotion;
  final bool isLoading;
  final String? errorMessage;
  final DateTime selectedDate;
  final PeriodType selectedPeriod;
  final List<ChartDataPoint> chartData;

  DiaryStatisticState({
    this.emotionCounts = const {},
    this.totalDiaries = 0,
    this.mostFrequentEmotion,
    this.isLoading = false,
    this.errorMessage,
    DateTime? selectedDate,
    this.selectedPeriod = PeriodType.month,
    this.chartData = const [],
  }) : selectedDate = selectedDate ?? DateTime(2025, 10, 24);

  DiaryStatisticState copyWith({
    Map<EmotionType, int>? emotionCounts,
    int? totalDiaries,
    EmotionType? mostFrequentEmotion,
    bool? isLoading,
    String? errorMessage,
    DateTime? selectedDate,
    PeriodType? selectedPeriod,
    List<ChartDataPoint>? chartData,
  }) {
    return DiaryStatisticState(
      emotionCounts: emotionCounts ?? this.emotionCounts,
      totalDiaries: totalDiaries ?? this.totalDiaries,
      mostFrequentEmotion: mostFrequentEmotion ?? this.mostFrequentEmotion,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      chartData: chartData ?? this.chartData,
    );
  }
}

enum PeriodType {
  week('주간'),
  month('월간'),
  year('연간');

  final String label;
  const PeriodType(this.label);
}

class ChartDataPoint {
  final String label; // x축 레이블
  final EmotionType emotion;
  final int count;
  final DateTime date;

  const ChartDataPoint({
    required this.label,
    required this.emotion,
    required this.count,
    required this.date,
  });
}

class EmotionStatItem {
  final EmotionType type;
  final int count;
  final double percentage;

  EmotionStatItem({
    required this.type,
    required this.count,
    required this.percentage,
  });
}

class DailyEmotionData {
  final DateTime date;
  final EmotionType? emotion;
  final int count;

  const DailyEmotionData({required this.date, this.emotion, this.count = 0});
}
