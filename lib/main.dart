import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/database/isar_service.dart';
import 'package:line_a_day/core/storage/storage_keys.dart';
import 'package:line_a_day/core/storage/storage_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/presentation/list/diary_list_view.dart';
import 'package:line_a_day/features/diary/presentation/write/diary_write_view.dart';
import 'package:line_a_day/features/emoji/presentation/emoji_select_view.dart';
import 'package:line_a_day/features/emoji/presentation/state/emoji_select_state.dart';
import 'package:line_a_day/features/intro/presentation/intro_view.dart';
import 'package:line_a_day/features/diary/presentation/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([IsarService.initialize(), StorageService.initialize()]);
  await initializeDateFormatting('ko');
  runApp(const ProviderScope(child: LineAday()));
}

void init() async {}

class LineAday extends ConsumerWidget {
  const LineAday({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final appConfig = ref.watch(appConfigProvider);
    // 인트로 화면 확인
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasSeenIntro = prefs.getBool(StorageKeys.hasSeenIntro) ?? false;

    return MaterialApp(
      routes: {
        "intro": (context) => const IntroView(),
        "emojiSelect": (context) => const EmojiSelectView(),
        "diaryList": (context) => const DiaryListView(),
        "diaryWrite": (context) => const DiaryWriteView(),
        "main": (context) => const MainView(),
      },
      theme: AppTheme.lightTheme,
      // themeMode: getThemeMode(appConfig.themeMode),
      // themeMode: getThemeMode(appConfig.themeMode), //테마 변경가능하도록 할거임
      initialRoute: hasSeenIntro ? "main" : "intro",
    );
  }

  EmojiStyle getEmojiStyle(String style) {
    return style == "EmojiStyle.threeD"
        ? EmojiStyle.threeD
        : style == "EmojiStyle.flat"
        ? EmojiStyle.flat
        : EmojiStyle.sketch;
  }

  ThemeMode getThemeMode(String mode) {
    return mode == "ThemeMode.light"
        ? ThemeMode.light
        : mode == "ThemeMode.dark"
        ? ThemeMode.dark
        : ThemeMode.system;
  }
}
