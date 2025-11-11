import 'package:line_a_day/features/settings/domain/model/theme_model.dart';

class ThemeState {
  final ThemeSettings settings;
  final bool isLoading;
  final String? errorMessage;

  ThemeState({
    ThemeSettings? settings,
    this.isLoading = false,
    this.errorMessage,
  }) : settings = settings ?? const ThemeSettings();

  ThemeState copyWith({
    ThemeSettings? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ThemeState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
