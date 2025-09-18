import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/model/calendar_model.dart';

class CalendarNotifierProvider extends Notifier<CalendarModel> {
  @override
  CalendarModel build() {
    return CalendarModel(
      selectedDay: DateTime.now(),
      focusedDay: DateTime.now(),
      isExpaned: false,
    );
  }

  void onChangeCalendarDay(DateTime? selectedDay, DateTime? focusedDay) {
    state = state.copyWith(selectedDay: selectedDay, focusedDay: focusedDay);
  }

  void onChangeExpended(bool? isExpanded) {
    state = state.copyWith(isExpaned: isExpanded);
  }
}

final calendarProvider =
    NotifierProvider<CalendarNotifierProvider, CalendarModel>(() {
      return CalendarNotifierProvider();
    });
