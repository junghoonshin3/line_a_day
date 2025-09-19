import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/providers/calendar_notifier_provider.dart';
import 'package:line_a_day/widgets/diary_card_widget.dart';
import 'package:line_a_day/widgets/expanded_app_bar_content.dart';

import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final double expandedHeight = 400;
  late final ScrollController scrollController;
  late final Function() listener;
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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    listener = () {
      // 위젯이 아직 마운트되어 있는지 확인
      ref
          .read(calendarProvider.notifier)
          .onChangeExpended(
            scrollController.hasClients &&
                scrollController.offset > (expandedHeight - kToolbarHeight),
          );
    };
    scrollController.addListener(listener);
    // 한국어 로케일 초기화
    initializeDateFormatting('ko_KR', null);
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: IconButton(
        color: Colors.black,
        onPressed: () {},
        icon: const Icon(Icons.add_circle_rounded, size: 70),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: kToolbarHeight,
            centerTitle: false,
            pinned: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: calendarState.isExpanded ? 1 : 0,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "하루 한 줄(김밥아님)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.amber,
            flexibleSpace: FlexibleSpaceBar(
              background: ExpandedAppBarContent(
                focusedDay: calendarState.focusedDay,
                selectedDay: calendarState.selectedDay,
                onDaySelected: (p1, p2) {},
                onPageChanged: (p1) {},
              ),
            ),
          ),
          LineDiaryList(diaryItems: diaryItems),
        ],
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
