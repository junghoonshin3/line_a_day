import 'package:flutter/material.dart';
import 'package:line_a_day/features/auth/presentation/lock_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockManager {
  static final AppLockManager _instance = AppLockManager._internal();
  factory AppLockManager() => _instance;
  AppLockManager._internal();

  bool _isShowingLockScreen = false;
  bool _isFirstLaunch = true; // 첫 실행 여부

  // 포그라운드 상태에서는 절대 잠금 안 함
  bool shouldShowLockScreen(
    SharedPreferences prefs,
    Duration? backgroundDuration,
  ) {
    final isLockEnabled = prefs.getBool('lock_enabled') ?? false;

    if (!isLockEnabled) {
      print('잠금 비활성화됨');
      return false;
    }

    // 첫 실행 시에만 잠금
    if (_isFirstLaunch) {
      print('첫 실행 - 잠금 필요');
      return true;
    }

    // 백그라운드 시간이 없으면 잠금 안 함 (포그라운드 상태)
    if (backgroundDuration == null) {
      print('포그라운드 상태 - 잠금 안 함');
      return false;
    }

    // 타임아웃 설정 가져오기
    final timeoutSeconds = prefs.getInt('lock_timeout_seconds') ?? 30;

    print('백그라운드 시간: ${backgroundDuration.inSeconds}초');
    print('타임아웃 설정: $timeoutSeconds초');

    // 즉시 잠금 (0초)
    if (timeoutSeconds == 0) {
      print('즉시 잠금 설정 - 잠금 필요');
      return true;
    }

    // 설정된 타임아웃 체크
    final shouldLock = backgroundDuration.inSeconds >= timeoutSeconds;
    print('잠금 필요: $shouldLock');

    return shouldLock;
  }

  Future<bool> showLockScreen(
    BuildContext context,
    SharedPreferences prefs,
  ) async {
    if (_isShowingLockScreen) {
      print('이미 잠금 화면이 표시 중');
      return false;
    }

    _isShowingLockScreen = true;

    try {
      final isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      print('잠금 화면 표시 (생체인증: $isBiometricEnabled)');

      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => LockView(showBiometric: isBiometricEnabled),
          fullscreenDialog: true,
        ),
      );

      if (result == true) {
        _isFirstLaunch = false; // 잠금 해제 후 첫 실행 플래그 해제
        print('잠금 해제 성공');
        return true;
      }

      print('잠금 해제 실패 또는 취소');
      return false;
    } finally {
      _isShowingLockScreen = false;
    }
  }

  void resetFirstLaunch() {
    print('첫 실행 플래그 초기화');
    _isFirstLaunch = true;
  }

  bool get isFirstLaunch => _isFirstLaunch;
}
