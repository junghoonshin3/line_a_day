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
  late final AppLockManager _lockManager;

  @override
  void initState() {
    super.initState();
    _lockManager = AppLockManager();
    // 백그라운드에서 포그라운드로 복귀 시 콜백 등록
    AppLifecycleService().addBackgroundCallback(_onBackgroundReturn);

    // 초기 잠금 확인 (앱 최초 실행 시에만)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialLock();
    });
  }

  @override
  void dispose() {
    AppLifecycleService().removeBackgroundCallback(_onBackgroundReturn);
    super.dispose();
  }

  // 앱 최초 실행 시에만 잠금 확인
  Future<void> _checkInitialLock() async {
    if (_isInitialLockChecked) return;
    _isInitialLockChecked = true;

    final prefs = ref.read(sharedPreferencesProvider);
    print('=== 초기 잠금 확인 ===');

    // 첫 실행이고 잠금이 활성화되어 있으면 잠금 표시
    if (_lockManager.shouldShowLockScreen(prefs, null)) {
      await _showLockScreen();
    } else {
      print('초기 잠금 불필요');
    }
  }

  // 백그라운드에서 복귀 시 호출
  void _onBackgroundReturn(Duration backgroundDuration) {
    print('=== 백그라운드 복귀 감지 ===');
    print('백그라운드 시간: ${backgroundDuration.inSeconds}초');

    final prefs = ref.read(sharedPreferencesProvider);

    // 백그라운드 시간에 따라 잠금 필요 여부 판단
    if (_lockManager.shouldShowLockScreen(prefs, backgroundDuration)) {
      print('잠금 필요 - 잠금 화면 표시');
      _showLockScreen();
    } else {
      print('잠금 불필요 - 그대로 진행');
    }
  }

  Future<void> _showLockScreen() async {
    // 네비게이터가 준비될 때까지 대기
    await Future.delayed(const Duration(milliseconds: 100));

    final context = _navigatorKey.currentContext;
    if (context == null) {
      print('네비게이터 컨텍스트 없음');
      return;
    }

    final prefs = ref.read(sharedPreferencesProvider);

    final unlocked = await _lockManager.showLockScreen(context, prefs);

    if (!unlocked) {
      print('잠금 해제 실패');
      // 사용자가 취소하거나 실패한 경우
      // 앱을 강제 종료하지 않고 계속 잠금 화면 유지
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
