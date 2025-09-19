import 'package:flutter/material.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';

class ExpandedAppBarContent extends StatelessWidget {
  const ExpandedAppBarContent({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime p1, DateTime p2) onDaySelected;
  final Function(DateTime p1) onPageChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LineCalendarWidget(
          focusedDay: focusedDay,
          selectedDay: selectedDay,
          isExpanded: true,
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
