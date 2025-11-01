import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/services/auth_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/auth/presentation/state/lock_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockViewModel extends StateNotifier<LockState> {
  final SharedPreferences _prefs;
  final AuthService _authService;
  Timer? _lockTimer;

  static const int maxFailedAttempts = 5;
  static const int lockDurationMinutes = 5;

  LockViewModel({
    required SharedPreferences prefs,
    required AuthService authService,
  }) : _prefs = prefs,
       _authService = authService,
       super(LockState()) {
    _checkTemporaryLock();
  }

  void _checkTemporaryLock() {
    final lockedUntilStr = _prefs.getString('locked_until');
    if (lockedUntilStr != null) {
      final lockedUntil = DateTime.parse(lockedUntilStr);
      if (DateTime.now().isBefore(lockedUntil)) {
        state = state.copyWith(
          lockedUntil: lockedUntil,
          failedAttempts: maxFailedAttempts,
        );
        _startLockTimer();
      } else {
        // 잠금 시간이 지났으면 초기화
        _prefs.remove('locked_until');
        _prefs.remove('failed_attempts');
      }
    } else {
      // 실패 횟수 복원
      final failedAttempts = _prefs.getInt('failed_attempts') ?? 0;
      state = state.copyWith(failedAttempts: failedAttempts);
    }
  }

  void _startLockTimer() {
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isTemporarilyLocked) {
        timer.cancel();
        state = state.copyWith(clearLockedUntil: true, failedAttempts: 0);
        _prefs.remove('locked_until');
        _prefs.remove('failed_attempts');
      } else {
        // UI 업데이트를 위해 상태 복사
        state = state.copyWith();
      }
    });
  }

  Future<bool> verifyPassword(String password) async {
    if (state.isTemporarilyLocked) {
      state = state.copyWith(
        errorMessage:
            '너무 많이 시도했습니다. ${_formatDuration(state.remainingLockTime!)} 후 다시 시도하세요.',
      );
      return false;
    }

    state = state.copyWith(isAuthenticating: true, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 500)); // 너무 빠른 시도 방지

    final isValid = await _authService.verifyPassword(_prefs, password);

    if (isValid) {
      // 성공: 실패 횟수 초기화
      await _prefs.remove('failed_attempts');
      await _prefs.remove('locked_until');
      state = state.copyWith(
        isAuthenticating: false,
        failedAttempts: 0,
        clearLockedUntil: true,
      );
      return true;
    } else {
      // 실패: 실패 횟수 증가
      final newFailedAttempts = state.failedAttempts + 1;
      await _prefs.setInt('failed_attempts', newFailedAttempts);

      if (newFailedAttempts >= maxFailedAttempts) {
        // 최대 시도 횟수 초과: 임시 잠금
        final lockedUntil = DateTime.now().add(
          const Duration(minutes: lockDurationMinutes),
        );
        await _prefs.setString('locked_until', lockedUntil.toIso8601String());

        state = state.copyWith(
          isAuthenticating: false,
          failedAttempts: newFailedAttempts,
          lockedUntil: lockedUntil,
          errorMessage: '너무 많이 시도했습니다. $lockDurationMinutes분 후 다시 시도하세요.',
        );

        _startLockTimer();
      } else {
        state = state.copyWith(
          isAuthenticating: false,
          failedAttempts: newFailedAttempts,
          errorMessage:
              '비밀번호가 올바르지 않습니다 (${maxFailedAttempts - newFailedAttempts}회 남음)',
        );
      }

      return false;
    }
  }

  Future<bool> verifyBiometric() async {
    if (state.isTemporarilyLocked) {
      state = state.copyWith(
        errorMessage:
            '너무 많이 시도했습니다. ${_formatDuration(state.remainingLockTime!)} 후 다시 시도하세요.',
      );
      return false;
    }

    state = state.copyWith(isAuthenticating: true, errorMessage: null);

    try {
      final success = await _authService.authenticate();

      if (success) {
        // 생체 인증 성공: 실패 횟수 초기화
        await _prefs.remove('failed_attempts');
        await _prefs.remove('locked_until');
        state = state.copyWith(
          isAuthenticating: false,
          failedAttempts: 0,
          clearLockedUntil: true,
        );
      } else {
        state = state.copyWith(
          isAuthenticating: false,
          errorMessage: '생체 인증에 실패했습니다',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isAuthenticating: false,
        errorMessage: '생체 인증 오류: $e',
      );
      return false;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes분 $seconds초';
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    super.dispose();
  }
}

final lockViewModelProvider =
    StateNotifierProvider.autoDispose<LockViewModel, LockState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return LockViewModel(prefs: prefs, authService: AuthService());
    });
