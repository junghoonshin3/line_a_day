import 'package:line_a_day/core/base/base_state.dart';

class SecuritySettingsState extends BaseState {
  final bool isLockEnabled;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;

  SecuritySettingsState({
    this.isLockEnabled = false,
    this.isBiometricEnabled = false,
    this.isBiometricAvailable = false,
    super.isLoading = false,
    super.errorMessage,
  });

  SecuritySettingsState copyWith({
    bool? isLockEnabled,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SecuritySettingsState(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
