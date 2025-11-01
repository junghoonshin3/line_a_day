class SecuritySettingsState {
  final bool isLockEnabled;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final String? errorMessage;

  SecuritySettingsState({
    this.isLockEnabled = false,
    this.isBiometricEnabled = false,
    this.isBiometricAvailable = false,
    this.errorMessage,
  });

  SecuritySettingsState copyWith({
    bool? isLockEnabled,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    String? errorMessage,
  }) {
    return SecuritySettingsState(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      errorMessage: errorMessage,
    );
  }
}
