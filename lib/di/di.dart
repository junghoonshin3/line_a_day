import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/app/config/config.dart';
import 'package:line_a_day/core/db/local_db.dart';
import 'package:line_a_day/core/db/local_db_impl.dart';
import 'package:line_a_day/features/emoji/presentation/emoji_select_view_model.dart';
import 'package:line_a_day/features/emoji/presentation/state/emoji_select_state.dart';
import 'package:line_a_day/repository/diary_list_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//local db
final localDatabaseProvider = Provider<LocalDb>((ref) {
  return LocalDbImpl();
});

//repository

//repository - diary
final diaryRepositoryProvider = Provider<DiaryListRepository>((ref) {
  return DiaryListRepositoryImpl();
});

//ViewModel
//ViewModel - emoji
final emojiSelectViewModelProvider =
    StateNotifierProvider<EmojiSelectViewModel, EmojiSelectState>(
      (ref) => EmojiSelectViewModel(ref.read(appConfigProvider.notifier)),
    );

//sharedRef
final sharedRefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final appConfigProvider =
    StateNotifierProvider<AppConfigNotifier, AppConfigState>((ref) {
      final pref = ref.watch(sharedRefProvider);

      // 비동기 초기화
      return AppConfigNotifier(pref: pref);
    });
