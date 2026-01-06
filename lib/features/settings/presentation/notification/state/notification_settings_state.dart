import 'package:flutter/material.dart';
import 'package:line_a_day/core/base/base_state.dart';

class NotificationSettingsState extends BaseState {
  final bool isEnabled;
  final TimeOfDay reminderTime;
  final List<int> reminderDays; // 0=월, 1=화, ..., 6=일

  NotificationSettingsState({
    this.isEnabled = false,
    TimeOfDay? reminderTime,
    this.reminderDays = const [0, 1, 2, 3, 4, 5, 6],
    super.isLoading = false,
    super.errorMessage,
  }) : reminderTime = reminderTime ?? const TimeOfDay(hour: 21, minute: 0);

  NotificationSettingsState copyWith({
    bool? isEnabled,
    TimeOfDay? reminderTime,
    List<int>? reminderDays,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
