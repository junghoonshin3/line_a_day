class SettingState {
  final int totalDiaries;
  final int totalDays;
  final DateTime joinDate;
  final double averagePerDay;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? recentTime;

  SettingState({
    this.totalDiaries = 0,
    this.totalDays = 0,
    DateTime? joinDate,
    this.isLoading = false,
    this.errorMessage,
    this.averagePerDay = 0.0,
    DateTime? recentTime,
  }) : joinDate = joinDate ?? DateTime.now(),
       recentTime = recentTime ?? DateTime.now();

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
      totalDiaries: totalDiaries ?? this.totalDiaries,
      totalDays: totalDays ?? this.totalDays,
      joinDate: joinDate ?? this.joinDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      averagePerDay: averagePerDay ?? this.averagePerDay,
      recentTime: recentTime ?? this.recentTime,
    );
  }
}
