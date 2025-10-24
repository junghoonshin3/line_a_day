import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_a_day/core/app/config/routes.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/database/isar_service.dart';
import 'package:line_a_day/core/storage/storage_keys.dart';
import 'package:line_a_day/core/storage/storage_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/emoji/presentation/select/state/emoji_select_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([IsarService.initialize(), StorageService.initialize()]);
  await initializeDateFormatting('ko');
  runApp(const ProviderScope(child: LineAday()));
}

class LineAday extends ConsumerWidget {
  const LineAday({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 인트로 화면 확인
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasSeenIntro = prefs.getBool(StorageKeys.hasSeenIntro) ?? false;

    return MaterialApp(
      title: 'Line A Day',
      theme: AppTheme.lightTheme,
      // 기본 routes (arguments 없는 경로)
      routes: AppRoutes.getRoutes(),
      // arguments가 필요한 routes 처리
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // 초기 화면 설정
      initialRoute: hasSeenIntro ? AppRoutes.main : AppRoutes.intro,
      // // 디버그 배너 제거 (선택사항)
      // debugShowCheckedModeBanner: false,
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
