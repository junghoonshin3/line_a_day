import 'package:flutter/material.dart';

class AppLifecycleService extends WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  factory AppLifecycleService() => _instance;
  AppLifecycleService._internal();

  DateTime? _lastPausedTime;
  final List<VoidCallback> _resumeCallbacks = [];

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void addResumeCallback(VoidCallback callback) {
    _resumeCallbacks.add(callback);
  }

  void removeResumeCallback(VoidCallback callback) {
    _resumeCallbacks.remove(callback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('앱 생명주기 변경: $state');

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // 앱이 백그라운드로 갈 때
        _lastPausedTime = DateTime.now();
        print('앱 일시정지 시간: $_lastPausedTime');
        break;

      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 올 때
        if (_lastPausedTime != null) {
          final duration = DateTime.now().difference(_lastPausedTime!);
          print('앱 백그라운드 시간: ${duration.inSeconds}초');

          // 콜백 실행
          for (final callback in _resumeCallbacks) {
            callback();
          }
        }
        break;

      default:
        break;
    }
  }

  Duration? get timeSinceLastPause {
    if (_lastPausedTime == null) return null;
    return DateTime.now().difference(_lastPausedTime!);
  }
}
