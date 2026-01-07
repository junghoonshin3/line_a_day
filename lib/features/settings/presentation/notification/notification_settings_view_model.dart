import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/services/notification_service.dart';
import 'package:line_a_day/features/settings/presentation/notification/state/notification_settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsViewModel
    extends StateNotifier<NotificationSettingsState> {
  final SharedPreferences _prefs;
  final NotificationService _notificationService;

  NotificationSettingsViewModel({
    required SharedPreferences prefs,
    required NotificationService notificationService,
  }) : _prefs = prefs,
       _notificationService = notificationService,
       super(NotificationSettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isEnabled = _prefs.getBool('notification_enabled') ?? false;
    final hour = _prefs.getInt('notification_hour') ?? 21;
    final minute = _prefs.getInt('notification_minute') ?? 0;
    final daysString = _prefs.getString('notification_days') ?? '0,1,2,3,4,5,6';
    final days = daysString.split(',').map((e) => int.parse(e)).toList();

    state = state.copyWith(
      isEnabled: isEnabled,
      reminderTime: TimeOfDay(hour: hour, minute: minute),
      reminderDays: days,
    );
  }

  Future<void> toggleNotification(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        state = state.copyWith(errorMessage: '알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
        return;
      }

      await _scheduleNotifications();
    } else {
      await _notificationService.cancelAll();
    }

    await _prefs.setBool('notification_enabled', enabled);
    state = state.copyWith(isEnabled: enabled);
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    await _prefs.setInt('notification_hour', time.hour);
    await _prefs.setInt('notification_minute', time.minute);
    state = state.copyWith(reminderTime: time);

    if (state.isEnabled) {
      await _scheduleNotifications();
    }
  }

  Future<void> updateReminderDays(List<int> days) async {
    await _prefs.setString('notification_days', days.join(','));
    state = state.copyWith(reminderDays: days);

    if (state.isEnabled) {
      await _scheduleNotifications();
    }
  }

  Future<void> _scheduleNotifications() async {
    await _notificationService.scheduleReminder(
      time: state.reminderTime,
      weekdays: state.reminderDays,
    );
  }
}
