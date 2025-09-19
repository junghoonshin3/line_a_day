import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class LineCalendarWidget extends StatelessWidget {
  const LineCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.isExpanded,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final bool isExpanded;
  final Function(DateTime p1, DateTime p2) onDaySelected;
  final Function(DateTime p1) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<dynamic>(
      locale: 'ko_KR',
      firstDay: DateTime(2000, 1, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,

      // 한국어 헤더 설정
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) {
          return DateFormat.yMMMM('ko_KR').format(date);
        },
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headerPadding: const EdgeInsets.symmetric(vertical: 8),
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),

      // 요일 스타일
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        weekendStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      // 날짜 스타일
      calendarStyle: CalendarStyle(
        cellMargin: const EdgeInsets.all(2),
        cellPadding: EdgeInsets.zero,

        // 기본 날짜 스타일
        defaultTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),

        // 주말 스타일
        weekendTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),

        // 선택된 날짜 스타일
        selectedDecoration: const BoxDecoration(
          color: DiaryTheme.warmOrange,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // 오늘 날짜 스타일
        todayDecoration: BoxDecoration(
          color: DiaryTheme.coralPink.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // 다른 달 날짜 스타일
        outsideTextStyle: const TextStyle(fontSize: 12, color: Colors.black26),

        // 마커 스타일 (일기가 있는 날)
        markersMaxCount: 1,
        markerDecoration: const BoxDecoration(
          color: DiaryTheme.mintGreen,
          shape: BoxShape.circle,
        ),
        markerMargin: const EdgeInsets.symmetric(horizontal: 1),
        markerSize: 4,
      ),

      // 이벤트 콜백
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,

      // 일기가 있는 날짜들을 표시 (예시)
      eventLoader: (day) {
        // 여기서 해당 날짜에 일기가 있는지 확인
        // 예시: 5일, 15일, 25일에 일기가 있다고 가정
        if (day.day == 5 || day.day == 15 || day.day == 25) {
          return ['diary'];
        }
        return [];
      },
    );
  }
}
