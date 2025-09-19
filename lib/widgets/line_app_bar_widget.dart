import 'package:flutter/material.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';

class LineAppBar extends StatefulWidget {
  final void Function()? onChangeCalendarMode;
  final Widget? calendarWidget;
  final double calendarHeight;
  const LineAppBar({
    super.key,
    this.onChangeCalendarMode,
    this.calendarWidget,
    required this.calendarHeight,
  });

  @override
  State<LineAppBar> createState() => _LineAppBarState();
}

class _LineAppBarState extends State<LineAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: kToolbarHeight,
      expandedHeight: 300,
      backgroundColor: Colors.greenAccent,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text("하루 한 줄"),
        titlePadding: EdgeInsets.only(left: 10, bottom: 10),
      ),
      actions: [
        IconButton(
          onPressed: widget.onChangeCalendarMode,
          icon: const Icon(Icons.calendar_month_rounded),
        ),
      ],
      floating: false,
    );
  }
}
