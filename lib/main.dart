import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_a_day/core/app/config/routes.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/database/isar_service.dart';
import 'package:line_a_day/core/services/app_lifecycle_service.dart';
import 'package:line_a_day/core/services/app_lock_manager.dart';
import 'package:line_a_day/core/services/notification_service.dart';
import 'package:line_a_day/core/storage/storage_keys.dart';
import 'package:line_a_day/core/storage/storage_service.dart';
import 'package:line_a_day/di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    IsarService.initialize(),
    StorageService.initialize(),
    NotificationService().initialize(),
  ]);

  await initializeDateFormatting('ko');

  // 앱 생명주기 서비스 초기화
  AppLifecycleService().initialize();

  runApp(const ProviderScope(child: LineAday()));
}

class LineAday extends ConsumerStatefulWidget {
  const LineAday({super.key});

  @override
  ConsumerState<LineAday> createState() => _LineadayState();
}

class _LineadayState extends ConsumerState<LineAday> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isInitialLockChecked = false;

  @override
  void initState() {
    super.initState();

    // 앱 재시작 시 잠금 확인
    AppLifecycleService().addResumeCallback(_onAppResumed);

    // 초기 잠금 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialLock();
    });
  }

  @override
  void dispose() {
    AppLifecycleService().removeResumeCallback(_onAppResumed);
    super.dispose();
  }

  Future<void> _checkInitialLock() async {
    if (_isInitialLockChecked) return;
    _isInitialLockChecked = true;

    final prefs = ref.read(sharedPreferencesProvider);
    final lockManager = AppLockManager();

    if (lockManager.shouldShowLockScreen(prefs)) {
      await _showLockScreen();
    }
  }

  void _onAppResumed() {
    print('앱이 포그라운드로 복귀');

    final prefs = ref.read(sharedPreferencesProvider);
    final lockManager = AppLockManager();

    if (lockManager.shouldShowLockScreen(prefs)) {
      _showLockScreen();
    }
  }

  Future<void> _showLockScreen() async {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    final lockManager = AppLockManager();

    final unlocked = await lockManager.showLockScreen(context, prefs);

    if (!unlocked) {
      // 잠금 해제 실패 시 (뒤로가기 등) 앱 종료는 하지 않음
      // 사용자가 직접 앱을 종료하거나 다시 시도할 수 있음
      print('잠금 해제 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasSeenIntro = prefs.getBool(StorageKeys.hasSeenIntro) ?? false;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Line A Day',
      theme: AppTheme.lightTheme,
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: hasSeenIntro ? AppRoutes.main : AppRoutes.intro,
      debugShowCheckedModeBanner: false,
    );
  }
}
