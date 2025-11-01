import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/settings/presentation/state/setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingViewModel extends StateNotifier<SettingState> {
  final DiaryRepository _diaryRepository;
  final SharedPreferences _prefs;

  SettingViewModel({
    required DiaryRepository diaryRepository,
    required SharedPreferences prefs,
  }) : _diaryRepository = diaryRepository,
       _prefs = prefs,
       super(SettingState()) {
    _loadStatistics();
  }

  void _loadStatistics() async {
    state = state.copyWith(isLoading: true);
    final totalDiaries = await _diaryRepository.getAllDiaries();
    final uniqueDates = <String>{};
    for (final diary in totalDiaries) {
      final dateKey =
          '${diary.createdAt.year}-${diary.createdAt.month}-${diary.createdAt.day}';
      uniqueDates.add(dateKey);
    }

    final recentTime = DateTime(
      0,
      1,
      1,
      totalDiaries.isNotEmpty ? totalDiaries.first.createdAt.hour : 0,
      totalDiaries.isNotEmpty ? totalDiaries.first.createdAt.minute : 0,
    );
    // 보기 좋게 포맷 (예: 오후 10시 30분)

    // 첫 일기 날짜 찾기
    totalDiaries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // 평균 작성 시간 계산 (첫 일기일부터 오늘까지)

    final totalDays = uniqueDates.length;
    final averagePerDay = totalDays == 0
        ? 0.0
        : (totalDiaries.length / totalDays);

    state = state.copyWith(
      totalDiaries: totalDiaries.length,
      totalDays: uniqueDates.length,
      averagePerDay: averagePerDay,
      recentTime: recentTime,
      isLoading: false,
    );
  }
}

final settingViewModelProvider =
    StateNotifierProvider.autoDispose<SettingViewModel, SettingState>((ref) {
      final diaryRepository = ref.watch(diaryRepositoryProvider);
      final prefs = ref.watch(sharedPreferencesProvider);
      return SettingViewModel(diaryRepository: diaryRepository, prefs: prefs);
    });
