import 'package:flutter/material.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/detail/diary_detail_view.dart';
import 'package:line_a_day/features/diary/presentation/list/diary_list_view.dart';
import 'package:line_a_day/features/diary/presentation/main_view.dart';
import 'package:line_a_day/features/diary/presentation/write/diary_write_view.dart';
import 'package:line_a_day/features/emoji/presentation/emoji_select_view.dart';
import 'package:line_a_day/features/intro/presentation/intro_view.dart';

class AppRoutes {
  // Route names
  static const String intro = 'intro';
  static const String emojiSelect = 'emojiSelect';
  static const String main = 'main';
  static const String diaryList = 'diaryList';
  static const String diaryWrite = 'diaryWrite';
  static const String diaryDetail = 'diaryDetail';

  // Routes Map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      intro: (context) => const IntroView(),
      emojiSelect: (context) => const EmojiSelectView(),
      main: (context) => const MainView(),
      diaryList: (context) => const DiaryListView(),
      diaryWrite: (context) => const DiaryWriteView(),
    };
  }

  // onGenerateRoute for routes with arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case diaryDetail:
        // arguments로 diaryId를 전달받음
        final diaryId = settings.arguments as int?;
        if (diaryId == null) {
          return _errorRoute('일기 ID가 필요합니다');
        }
        return MaterialPageRoute(
          builder: (_) => DiaryDetailView(diaryId: diaryId),
          settings: settings,
        );

      case diaryWrite:
        // arguments로 DiaryModel을 받으면 편집 모드
        final diary = settings.arguments as DiaryModel?;
        return MaterialPageRoute(
          builder: (_) => const DiaryWriteView(),
          settings: RouteSettings(name: diaryWrite, arguments: diary),
        );

      default:
        // 기본 routes에서 찾기
        final routes = getRoutes();
        if (routes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: routes[settings.name]!,
            settings: settings,
          );
        }
        return _errorRoute('페이지를 찾을 수 없습니다: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('오류'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
