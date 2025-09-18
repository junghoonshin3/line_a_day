import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/providers/calendar_notifier_provider.dart';
import 'package:line_a_day/widgets/diary_card_widget.dart';
import 'package:line_a_day/widgets/line_app_bar_widget.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:measure_size/measure_size.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<String> diaryItems = [
    "1",
    "2\n2232313413\n12312312\n\n1312312312",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
    "3",
  ];

  double toolbarHeight = 0;

  @override
  void initState() {
    super.initState();
    // 한국어 로케일 초기화
    initializeDateFormatting('ko_KR', null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarProvider);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: IconButton(
          color: Colors.black,
          onPressed: () {},
          icon: const Icon(Icons.add_circle_rounded, size: 70),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: MeasureSize(
                onChange: (size) => setState(() => toolbarHeight = size.height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("하루 한줄"),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                      LineCalendarWidget(
                        focusedDay: calendarState.focusedDay,
                        selectedDay: calendarState.selectedDay,
                        isExpanded: calendarState.isExpaned,
                        onDaySelected: (p1, p2) {},
                        onPageChanged: (p1) {},
                      ),
                    ],
                  ),
                ),
              ),
              toolbarHeight: toolbarHeight,
              floating: true,
            ),
          ],
          body: LineDiaryList(diaryItems: diaryItems),
        ),
        // CustomScrollView(
        //   slivers: [
        //     LineAppBar(
        //       onChangeCalendarMode: () {
        //         ref
        //             .read(calendarProvider.notifier)
        //             .onChangeExpended(!calendarState.isExpaned);
        //       },
        //       isExpanded: calendarState.isExpaned,
        //     ),
        //     LineDiaryList(diaryItems: diaryItems),
        //   ],
        // ),
      ),
    );
  }
}

class LineDiaryList extends StatelessWidget {
  const LineDiaryList({super.key, required this.diaryItems});

  final List<String> diaryItems;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: diaryItems.length,
        itemBuilder: (context, index) => DiaryCardWidget(
          title: diaryItems[index],
          content: diaryItems[index],
          date: diaryItems[index],
        ),
      ),
    );
  }
}
