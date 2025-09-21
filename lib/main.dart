import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_a_day/screens/home_screen.dart';
import 'package:line_a_day/theme.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const ProviderScope(child: LineAday()));
}

class LineAday extends StatelessWidget {
  const LineAday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: DiaryTheme.lightTheme,
      darkTheme: DiaryTheme.darkTheme, // 선택사항
      themeMode: ThemeMode.light, //
      home: const HomeScreen(),
    );
  }
}
