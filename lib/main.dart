import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/db/local_db_impl.dart';
import 'package:line_a_day/di/di.dart';
import 'package:line_a_day/features/main/diary_list/diary_list_view.dart';
import 'package:line_a_day/features/diary_write/write/diary_write_view.dart';
import 'package:line_a_day/features/diary_write/mood/diary_mood_view.dart';
import 'package:line_a_day/features/emoji/presentation/emoji_select_view.dart';
import 'package:line_a_day/features/emoji/presentation/state/emoji_select_state.dart';
import 'package:line_a_day/features/intro/presentation/intro_view.dart';
import 'package:line_a_day/features/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  final db = LocalDbImpl();
  final pref = await SharedPreferences.getInstance();
  await db.initDb();
  runApp(
    ProviderScope(
      overrides: [
        localDatabaseProvider.overrideWithValue(db),
        sharedRefProvider.overrideWithValue(pref),
      ],
      child: const LineAday(),
    ),
  );
}

void init() async {}

class LineAday extends ConsumerWidget {
  const LineAday({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(appConfigProvider);
    final pref = ref.read(sharedRefProvider);
    final hasSeenIntro = pref.getBool('hasSeenIntro') ?? false;
    return MaterialApp(
      routes: {
        "intro": (context) => const IntroView(),
        "emojiSelect": (context) => const EmojiSelectView(),
        "diaryList": (context) => const DiaryListView(),
        "diaryMood": (context) => const DiaryMoodView(),
        "diaryWrite": (context) => const DiaryWriteView(),
        "main": (context) => const MainView(),
      },
      theme: AppTheme.lightTheme,
      themeMode: getThemeMode(appConfig.themeMode),
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
