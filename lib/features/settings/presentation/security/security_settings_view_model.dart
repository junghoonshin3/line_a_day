import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/services/auth_service.dart';
import 'package:line_a_day/features/settings/presentation/security/state/security_settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsViewModel extends StateNotifier<SecuritySettingsState> {
  final SharedPreferences _prefs;
  final AuthService _authService;

  SecuritySettingsViewModel({
    required SharedPreferences prefs,
    required AuthService authService,
  }) : _prefs = prefs,
       _authService = authService,
       super(SecuritySettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isLockEnabled = _prefs.getBool('lock_enabled') ?? false;
    final isBiometricEnabled = _prefs.getBool('biometric_enabled') ?? false;
    final isBiometricAvailable = await _authService.isBiometricAvailable();

    state = state.copyWith(
      isLockEnabled: isLockEnabled,
      isBiometricEnabled: isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable,
    );
  }

  Future<bool> enableLock(String password) async {
    await _authService.savePassword(_prefs, password);
    await _prefs.setBool('lock_enabled', true);
    state = state.copyWith(isLockEnabled: true);
    return true;
  }

  Future<void> disableLock() async {
    await _authService.removePassword(_prefs);
    await _prefs.setBool('lock_enabled', false);
    await _prefs.setBool('biometric_enabled', false);
    state = state.copyWith(isLockEnabled: false, isBiometricEnabled: false);
  }

  Future<bool> verifyPassword(String password) async {
    return await _authService.verifyPassword(_prefs, password);
  }

  Future<void> toggleBiometric(bool enabled) async {
    if (enabled) {
      final authenticated = await _authService.authenticate();
      if (!authenticated) {
        state = state.copyWith(errorMessage: '생체 인증에 실패했습니다');
        return;
      }
    }

    await _prefs.setBool('biometric_enabled', enabled);
    state = state.copyWith(isBiometricEnabled: enabled);
  }

  Future<void> clearErrorMessage() async {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> authenticate() async {
    if (state.isBiometricEnabled) {
      return await _authService.authenticate();
    }
    return false;
  }
}
