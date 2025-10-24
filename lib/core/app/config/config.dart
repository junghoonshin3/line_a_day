import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigState {
  final String emojiStyle;
  final String themeMode;
  AppConfigState({required this.emojiStyle, required this.themeMode});

  AppConfigState copyWith({String? emojiStyle, String? themeMode}) {
    return AppConfigState(
      emojiStyle: emojiStyle ?? this.emojiStyle,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppConfigNotifier extends StateNotifier<AppConfigState> {
  final SharedPreferences pref;

  AppConfigNotifier({required this.pref})
    : super(
        AppConfigState(
          emojiStyle: pref.getString("emoji_style") ?? "",
          themeMode: pref.getString("theme_mode") ?? "",
        ),
      );

  void updateEmojiStyle(String newStyle) {
    pref.setString("emoji_style", newStyle);
    pref.setBool("is_emoji_style_complete", true);
    state = state.copyWith(emojiStyle: newStyle);
  }

  void updateThemeMode(String themeMode) {
    pref.setString("theme_mode", themeMode);
    state = state.copyWith(themeMode: themeMode);
  }

  bool hasSeenIntro() {
    return pref.getBool("hasSeenIntro") ?? false;
  }
}
