import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/features/settings/domain/model/theme_model.dart';
import 'package:line_a_day/features/settings/presentation/theme/state/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends StateNotifier<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_settings';

  ThemeViewModel(this._prefs) : super(ThemeState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final settingsJson = _prefs.getString(_themeKey);
    if (settingsJson != null) {
      try {
        final settings = ThemeSettings.fromJson(jsonDecode(settingsJson));
        state = state.copyWith(settings: settings);
      } catch (e) {
        print('테마 설정 로드 실패: $e');
      }
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final newSettings = state.settings.copyWith(themeMode: mode);
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  Future<void> updateColorTheme(AppColorTheme colorTheme) async {
    final newSettings = state.settings.copyWith(colorTheme: colorTheme);
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  Future<void> _saveSettings(ThemeSettings settings) async {
    try {
      await _prefs.setString(_themeKey, jsonEncode(settings.toJson()));
    } catch (e) {
      state = state.copyWith(errorMessage: '테마 설정 저장 실패: $e');
    }
  }
}
