import 'package:flutter/material.dart';

enum AppColorTheme {
  blue('블루', Color(0xFF3B82F6), Color(0xFF8B5CF6)),
  purple('퍼플', Color(0xFF8B5CF6), Color(0xFFA855F7)),
  pink('핑크', Color(0xFFEC4899), Color(0xFFF472B6)),
  green('그린', Color(0xFF10B981), Color(0xFF34D399)),
  orange('오렌지', Color(0xFFF59E0B), Color(0xFFFB923C)),
  red('레드', Color(0xFFEF4444), Color(0xFFF87171));

  final String label;
  final Color primaryColor;
  final Color secondaryColor;

  const AppColorTheme(this.label, this.primaryColor, this.secondaryColor);

  LinearGradient get gradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ThemeSettings {
  final ThemeMode themeMode;
  final AppColorTheme colorTheme;

  const ThemeSettings({
    this.themeMode = ThemeMode.light,
    this.colorTheme = AppColorTheme.blue,
  });

  ThemeSettings copyWith({ThemeMode? themeMode, AppColorTheme? colorTheme}) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      colorTheme: colorTheme ?? this.colorTheme,
    );
  }

  Map<String, dynamic> toJson() {
    return {'themeMode': themeMode.name, 'colorTheme': colorTheme.name};
  }

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.light,
      ),
      colorTheme: AppColorTheme.values.firstWhere(
        (e) => e.name == json['colorTheme'],
        orElse: () => AppColorTheme.blue,
      ),
    );
  }
}
