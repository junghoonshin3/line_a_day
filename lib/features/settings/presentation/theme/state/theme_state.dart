import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/features/settings/domain/model/theme_model.dart';

class ThemeState extends BaseState {
  final ThemeSettings settings;

  ThemeState({
    ThemeSettings? settings,
    super.isLoading = false,
    super.errorMessage,
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
