class CalendarModel {
  const CalendarModel({
    required this.selectedDay,
    required this.focusedDay,
    required this.isExpanded,
  });

  // All properties should be `final` on our class.
  final DateTime selectedDay;
  final DateTime focusedDay;
  final bool isExpanded;

  CalendarModel copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    bool? isExpanded,
  }) {
    return CalendarModel(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
