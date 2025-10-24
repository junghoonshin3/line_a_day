// ═══════════════════════════════════════════════════════════════
// core/di/providers.dart
// Riverpod Provider 정의
// ═══════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/storage/storage_service.dart';
import 'package:line_a_day/features/diary/data/repository/diary_repository_impl.dart';
import 'package:line_a_day/features/diary/data/repository/draft_respository_impl.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/domain/repository/draft_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import 'package:line_a_day/core/app/config/config.dart';
import 'package:line_a_day/core/database/isar_service.dart';
import 'package:line_a_day/features/emoji/presentation/select/emoji_select_view_model.dart';
import 'package:line_a_day/features/emoji/presentation/select/state/emoji_select_state.dart';
import 'package:line_a_day/features/intro/presentation/intro_view_model.dart';
import 'package:line_a_day/features/intro/presentation/state/intro_state.dart';

/// Isar Provider
/// 앱 전체에서 동일한 Isar 인스턴스 사용
final isarProvider = Provider<Isar>((ref) {
  return IsarService.instance;
});

/// Isar 초기화 Provider
/// FutureProvider로 비동기 초기화
final isarInitProvider = FutureProvider<Isar>((ref) async {
  return await IsarService.initialize();
});

//ViewModel
//ViewModel - emoji
final emojiSelectViewModelProvider =
    StateNotifierProvider.autoDispose<EmojiSelectViewModel, EmojiSelectState>(
      (ref) => EmojiSelectViewModel(),
    );

final introViewModelProvider =
    StateNotifierProvider.autoDispose<IntroViewModel, IntroState>(
      (ref) => IntroViewModel(ref.watch(sharedPreferencesProvider)),
    );

//sharedRef
final sharedRefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// final appConfigProvider =
//     StateNotifierProvider<AppConfigNotifier, AppConfigState>((ref) {
//       final pref = ref.watch(sharedRefProvider);
//       return AppConfigNotifier(pref: pref);
//     });

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  return StorageService.instance;
});

// diaryRepositoryProvider
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return DiaryRepositoryImpl(isar);
});

// draftRepositoryProvider
final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DraftRespositoryImpl(prefs);
});
