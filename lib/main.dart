import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/screens/diary_list/diary_list_view.dart';
import 'package:line_a_day/helper/hive_helper.dart';
import 'package:line_a_day/screens/diary_write/write/diary_write_view.dart';
import 'package:line_a_day/screens/diary_write/mood/diary_mood_view.dart';
import 'package:line_a_day/screens/emoji/emoji_select_view.dart';

void main() async {
  await init();
  runApp(const ProviderScope(child: LineAday()));
}

Future<void> init() async {
  await HiveHelper().initHiveManager();
}

class LineAday extends StatelessWidget {
  const LineAday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "emojiSelect": (context) => const EmojiSelectView(),
        "diaryList": (context) => const DiaryListView(),
        "diaryMood": (context) => const DiaryMoodView(),
        "diaryWrite": (context) => const DiaryWriteView(),
      },
      themeMode: ThemeMode.light, //
      initialRoute: "emojiSelect",
    );
  }
}
