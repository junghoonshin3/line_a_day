class CalendarModel {
  const CalendarModel({
    required this.selectedDay,
    required this.focusedDay,
    required this.isExpaned,
  });

  // All properties should be `final` on our class.
  final DateTime selectedDay;
  final DateTime focusedDay;
  final bool isExpaned;

  CalendarModel copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    bool? isExpaned,
  }) {
    return CalendarModel(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      isExpaned: isExpaned ?? this.isExpaned,
    );
  }
}
