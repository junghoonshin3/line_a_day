import 'package:flutter/material.dart';

enum AppState { foreground, background }

class AppLifecycleService extends WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  factory AppLifecycleService() => _instance;
  AppLifecycleService._internal();

  DateTime? _backgroundTime;
  AppState _currentState = AppState.foreground;
  final List<Function(Duration)> _backgroundCallbacks = [];

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  // 백그라운드 진입 시 콜백 등록
  void addBackgroundCallback(Function(Duration) callback) {
    _backgroundCallbacks.add(callback);
  }

  void removeBackgroundCallback(Function(Duration) callback) {
    _backgroundCallbacks.remove(callback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('앱 생명주기 변경: $state');

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // 백그라운드로 진입
        if (_currentState == AppState.foreground) {
          _backgroundTime = DateTime.now();
          _currentState = AppState.background;
          print('백그라운드 진입: $_backgroundTime');
        }
        break;

      case AppLifecycleState.resumed:
        // 포그라운드로 복귀
        if (_currentState == AppState.background && _backgroundTime != null) {
          final duration = DateTime.now().difference(_backgroundTime!);
          print('포그라운드 복귀: 백그라운드 시간 ${duration.inSeconds}초');

          // 모든 콜백 실행
          for (final callback in _backgroundCallbacks) {
            callback(duration);
          }

          _currentState = AppState.foreground;
        }
        break;

      default:
        break;
    }
  }

  bool get isInBackground => _currentState == AppState.background;
  bool get isInForeground => _currentState == AppState.foreground;
  DateTime? get backgroundTime => _backgroundTime;

  Duration? get timeSinceBackground {
    if (_backgroundTime == null || _currentState == AppState.foreground) {
      return null;
    }
    return DateTime.now().difference(_backgroundTime!);
  }
}
