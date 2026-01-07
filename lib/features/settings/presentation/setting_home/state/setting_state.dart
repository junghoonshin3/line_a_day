import 'package:line_a_day/core/base/base_state.dart';

class SettingState extends BaseState {
  final int totalDiaries;
  final int totalDays;
  final DateTime joinDate;
  final double averagePerDay;
  final DateTime? recentTime;

  SettingState({
    this.totalDiaries = 0,
    this.totalDays = 0,
    DateTime? joinDate,
    this.averagePerDay = 0.0,
    DateTime? recentTime,
    super.isLoading = false,
    super.errorMessage,
  }) : joinDate = joinDate ?? DateTime.now(),
       recentTime = null;

  SettingState copyWith({
    int? totalDiaries,
    int? totalDays,
    DateTime? joinDate,
    bool? isLoading,
    String? errorMessage,
    double? averagePerDay,
    DateTime? recentTime,
  }) {
    return SettingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalDiaries: totalDiaries ?? this.totalDiaries,
      totalDays: totalDays ?? this.totalDays,
      joinDate: joinDate ?? this.joinDate,
      averagePerDay: averagePerDay ?? this.averagePerDay,
      recentTime: recentTime ?? this.recentTime,
    );
  }
}
