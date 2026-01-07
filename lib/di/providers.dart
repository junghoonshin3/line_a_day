// ═══════════════════════════════════════════════════════════════
// core/di/providers.dart
// Riverpod Provider 정의
// ═══════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/di/database_provider.dart';
import 'package:line_a_day/core/services/backup_service.dart';
import 'package:line_a_day/core/services/google_drive_service.dart';
import 'package:line_a_day/core/storage/storage_service.dart';
import 'package:line_a_day/features/diary/data/repository/diary_repository_impl.dart';
import 'package:line_a_day/features/diary/data/repository/draft_respository_impl.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/domain/repository/draft_repository.dart';
import 'package:line_a_day/features/settings/data/repository/backup_repository_impl.dart';
import 'package:line_a_day/features/settings/domain/repository/backup_repository.dart';
import 'package:line_a_day/features/settings/presentation/backup/%20backup_view_model.dart';
import 'package:line_a_day/features/settings/presentation/backup/state/backup_state.dart';
import 'package:line_a_day/features/settings/presentation/theme/state/theme_state.dart';
import 'package:line_a_day/features/settings/presentation/theme/theme_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/features/emoji/presentation/select/emoji_select_view_model.dart';
import 'package:line_a_day/features/emoji/presentation/select/state/emoji_select_state.dart';
import 'package:line_a_day/features/intro/presentation/intro_view_model.dart';
import 'package:line_a_day/features/intro/presentation/state/intro_state.dart';

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

// Services
final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final isar = ref.watch(isarProvider);
  return BackupService(isar);
});

// Repository
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepositoryImpl(
    diaryRepository: ref.watch(diaryRepositoryProvider),
    driveService: ref.watch(googleDriveServiceProvider),
    backupService: ref.watch(backupServiceProvider),
  );
});

// ViewModel
final backupViewModelProvider =
    StateNotifierProvider.autoDispose<BackupViewModel, BackupState>((ref) {
      return BackupViewModel(ref.watch(backupRepositoryProvider));
    });

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ThemeViewModel(prefs);
    });
