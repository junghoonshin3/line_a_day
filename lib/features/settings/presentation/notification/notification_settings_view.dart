import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/services/notification_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/settings/presentation/notification/state/notification_settings_state.dart';
import 'package:line_a_day/features/settings/presentation/notification/notification_settings_view_model.dart';
import 'package:line_a_day/widgets/settings/card_section.dart';

final notificationSettingsViewModelProvider =
    StateNotifierProvider.autoDispose<
      NotificationSettingsViewModel,
      NotificationSettingsState
    >((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return NotificationSettingsViewModel(
        prefs: prefs,
        notificationService: NotificationService(),
      );
    });

class NotificationSettingsView extends ConsumerWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationSettingsViewModelProvider);
    final viewModel = ref.read(notificationSettingsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Theme(
        data: ThemeData(
          highlightColor: Colors.white,
          splashColor: Colors.transparent,
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 알림 활성화 스위치
            CardSection(
              child: SwitchListTile(
                value: state.isEnabled,
                onChanged: (value) => viewModel.toggleNotification(value),
                title: const Text('일기 작성 알림', style: AppTheme.titleMedium),
                subtitle: const Text(
                  '설정한 시간에 일기 작성을 알려드립니다',
                  style: AppTheme.bodyMedium,
                ),
                activeThumbColor: AppTheme.primaryBlue,
              ),
            ),

            if (state.isEnabled) ...[
              const SizedBox(height: 20),

              // 알림 시간 설정
              CardSection(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.access_time, color: AppTheme.primaryBlue),
                  ),
                  title: const Text('알림 시간', style: AppTheme.titleMedium),
                  subtitle: Text(
                    _formatTime(state.reminderTime),
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _selectTime(context, viewModel, state.reminderTime),
                ),
              ),

              const SizedBox(height: 20),

              // 요일 선택
              CardSection(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('알림 요일', style: AppTheme.titleMedium),
                      const SizedBox(height: 16),
                      _buildWeekdaySelector(state, viewModel),
                    ],
                  ),
                ),
              ),
            ],

            if (state.errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppTheme.errorRed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector(
    NotificationSettingsState state,
    NotificationSettingsViewModel viewModel,
  ) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = state.reminderDays.contains(index);
        return GestureDetector(
          onTap: () {
            final newDays = List<int>.from(state.reminderDays);
            if (isSelected) {
              newDays.remove(index);
            } else {
              newDays.add(index);
            }
            newDays.sort();
            viewModel.updateReminderDays(newDays);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.primaryGradient : null,
              color: isSelected ? null : AppTheme.gray100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                weekdays[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.gray600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    return '$period $hour:$minute';
  }

  Future<void> _selectTime(
    BuildContext context,
    NotificationSettingsViewModel viewModel,
    TimeOfDay currentTime,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (time != null) {
      viewModel.updateReminderTime(time);
    }
  }
}
