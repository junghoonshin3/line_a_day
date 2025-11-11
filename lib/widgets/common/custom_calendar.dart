import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime? selectedDate;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(DateTime focusedDay) onPageChanged;
  final bool Function(DateTime date) hasEntryOnDate;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CalendarWidget({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.hasEntryOnDate,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      margin: margin ?? const EdgeInsets.all(20),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDate,
        enabledDayPredicate: (date) {
          return !date.isAfter(now);
        },
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.gray600),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.gray600),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTheme.labelMedium.copyWith(color: AppTheme.gray400),
          weekendStyle: AppTheme.labelMedium.copyWith(color: AppTheme.gray400),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryBlue, width: 2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          selectedTextStyle: AppTheme.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          weekendTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          outsideTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray300,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          markerSize: 4,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (hasEntryOnDate(date)) {
              return Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              );
            }
            return null;
          },
          headerTitleBuilder: (context, day) {
            return Center(
              child: Text(
                DateFormat("yyyy년 MM월", "ko").format(day),
                style: AppTheme.titleLarge,
              ),
            );
          },
        ),
      ),
    );
  }
}
