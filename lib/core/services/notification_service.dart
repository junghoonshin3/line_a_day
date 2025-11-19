import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // timezone 초기화 (중요!)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('알림 클릭: ${details.payload}');
      },
    );

    print('알림 초기화 결과: $initialized');
    _isInitialized = initialized ?? false;
  }

  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Android 13 이상 권한 요청
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final granted = await androidImplementation
          .requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS 권한 요청
    final iosImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      print('iOS 알림 권한: $granted');
      return granted ?? false;
    }

    return true;
  }

  Future<void> scheduleReminder({
    required TimeOfDay time,
    required List<int> weekdays,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    print('알림 스케줄링 시작: ${time.hour}:${time.minute}, 요일: $weekdays');

    // 기존 알림 모두 취소
    await _notifications.cancelAll();

    if (weekdays.isEmpty) {
      print('선택된 요일이 없습니다');
      return;
    }

    // 각 요일마다 알림 설정
    for (final weekday in weekdays) {
      await _scheduleDailyNotification(
        id: weekday,
        time: time,
        weekday: weekday + 1, // 0=월요일 -> 1=Monday
      );
    }

    // 설정된 알림 확인
    final pending = await _notifications.pendingNotificationRequests();
    print('설정된 알림 개수: ${pending.length}');
    for (final notification in pending) {
      print('알림 ID: ${notification.id}, 제목: ${notification.title}');
    }
  }

  Future<void> _scheduleDailyNotification({
    required int id,
    required TimeOfDay time,
    required int weekday,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      print('현재 시간: $now');

      // 오늘 날짜에 설정된 시간 생성
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      print('초기 스케줄 시간: $scheduledDate (요일: ${scheduledDate.weekday})');

      // 지정된 요일로 이동
      while (scheduledDate.weekday != weekday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // 이미 시간이 지났으면 다음 주로
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      print('최종 스케줄 시간: $scheduledDate (요일: ${scheduledDate.weekday})');

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        '일기 작성 알림',
        channelDescription: '매일 일기 작성을 알려드립니다',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        '일기 작성 시간이에요! 📝',
        '오늘 하루는 어떠셨나요? 소중한 순간을 기록해보세요.',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      print('알림 ID $id 스케줄링 완료');
    } catch (e) {
      print('알림 스케줄링 에러 (ID $id): $e');
    }
  }

  // 테스트용 즉시 알림
  Future<void> showTestNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      '테스트 알림',
      channelDescription: '알림 테스트용',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(999, '테스트 알림', '알림이 정상적으로 작동합니다! ✅', details);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    print('모든 알림 취소됨');
  }

  // 설정된 알림 목록 확인
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
