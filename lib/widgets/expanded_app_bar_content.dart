import 'package:flutter/material.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';

class ExpandedAppBarContent extends StatelessWidget {
  const ExpandedAppBarContent({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.isExpanded,
  });
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime p1, DateTime p2) onDaySelected;
  final Function(DateTime p1) onPageChanged;
  final bool isExpanded;
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        // LineCalendarWidget(
        //   focusedDay: focusedDay,
        //   selectedDay: selectedDay,
        //   isExpanded: isExpanded,
        //   onDaySelected: onDaySelected,
        //   onPageChanged: onPageChanged,
        // ),
      ],
    );
  }
}
