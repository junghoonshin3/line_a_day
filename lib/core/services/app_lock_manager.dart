import 'package:flutter/material.dart';
import 'package:line_a_day/features/auth/presentation/lock_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockManager {
  static final AppLockManager _instance = AppLockManager._internal();
  factory AppLockManager() => _instance;
  AppLockManager._internal();

  bool _isShowingLockScreen = false;
  DateTime? _lastUnlockTime;

  static const int lockTimeoutSeconds = 30; // 30초 후 자동 잠금

  bool shouldShowLockScreen(SharedPreferences prefs) {
    final isLockEnabled = prefs.getBool('lock_enabled') ?? false;

    if (!isLockEnabled) return false;

    // 첫 실행이거나 타임아웃이 지났으면 잠금
    if (_lastUnlockTime == null) return true;

    final elapsed = DateTime.now().difference(_lastUnlockTime!);
    return elapsed.inSeconds > lockTimeoutSeconds;
  }

  Future<bool> showLockScreen(
    BuildContext context,
    SharedPreferences prefs,
  ) async {
    if (_isShowingLockScreen) return false;

    _isShowingLockScreen = true;

    try {
      final isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => LockView(showBiometric: isBiometricEnabled),
          fullscreenDialog: true,
        ),
      );

      if (result == true) {
        _lastUnlockTime = DateTime.now();
        return true;
      }

      return false;
    } finally {
      _isShowingLockScreen = false;
    }
  }

  void resetUnlockTime() {
    _lastUnlockTime = null;
  }
}
