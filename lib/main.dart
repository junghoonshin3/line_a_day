import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/screens/diary_list/diary_list_view.dart';
import 'package:line_a_day/helper/hive_helper.dart';
import 'package:line_a_day/screens/diary_write/diary_write_view.dart';
import 'package:line_a_day/theme.dart';

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
        "diaryList": (context) => const DiaryListView(),
        "diaryWrite": (context) => const DiaryWriteView(),
      },
      theme: DiaryTheme.lightTheme,
      darkTheme: DiaryTheme.darkTheme, // 선택사항
      themeMode: ThemeMode.light, //
      initialRoute: "diaryList",
    );
  }
}
