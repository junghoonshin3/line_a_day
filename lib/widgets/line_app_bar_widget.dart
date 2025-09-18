import 'package:flutter/material.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';

class LineAppBar extends StatefulWidget {
  final void Function()? onChangeCalendarMode;
  final bool isExpanded;
  const LineAppBar({
    super.key,
    this.onChangeCalendarMode,
    required this.isExpanded,
  });

  @override
  State<LineAppBar> createState() => _LineAppBarState();
}

class _LineAppBarState extends State<LineAppBar> {
  double toolbarHeight = 0;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: kToolbarHeight,
      expandedHeight: 350,
      backgroundColor: Colors.greenAccent,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("하루 한 줄"),
              IconButton(
                onPressed: widget.onChangeCalendarMode,
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
          LineCalendarWidget(
            focusedDay: DateTime.now(),
            selectedDay: DateTime.now(),
            isExpanded: widget.isExpanded,
            onDaySelected: (p1, p2) {},
            onPageChanged: (p1) {},
          ),
        ],
      ),
      floating: true,
    );
  }
}
