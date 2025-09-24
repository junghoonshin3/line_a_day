import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/providers/calendar_notifier_provider.dart';
import 'package:line_a_day/screens/diary_list/diary_list_view_model.dart';
import 'package:line_a_day/widgets/diary_card_widget.dart';
import 'package:line_a_day/widgets/expanded_app_bar_content.dart';
import 'package:intl/date_symbol_data_local.dart';

class DiaryListView extends ConsumerStatefulWidget {
  const DiaryListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiaryListView();
}

class _DiaryListView extends ConsumerState<DiaryListView> {
  double expandedHeight = 150;
  late final ScrollController scrollController;
  late final Function() listener;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    listener = () {
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
    final diaryListState = ref.watch(diaryListViewModelProvider);
    final diaryListViewModel = ref.read(diaryListViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: IconButton(
        color: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed("diaryWrite");
        },
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
              child: const CollapsedAppBar(title: "하루 한 줄"),
            ),
            backgroundColor: Colors.amber,
            flexibleSpace: FlexibleSpaceBar(
              background: ExpandedAppBarContent(
                isExpanded: false,
                focusedDay: calendarState.focusedDay,
                selectedDay: calendarState.selectedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  ref
                      .read(calendarProvider.notifier)
                      .onChangeCalendarDay(selectedDay, focusedDay);
                  diaryListViewModel.getDiaryList(selectedDay);
                },
                onPageChanged: (p1) {
                  ref
                      .read(calendarProvider.notifier)
                      .onChangeCalendarDay(null, p1);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.amber,
              height: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LineDiaryList(diaryItems: diaryListState.diaryList),
        ],
      ),
    );
  }
}

class CollapsedAppBar extends StatelessWidget {
  final String title;
  const CollapsedAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class LineDiaryList extends StatelessWidget {
  const LineDiaryList({super.key, required this.diaryItems});

  final List<DiaryEntity> diaryItems;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: diaryItems.length,
        itemBuilder: (context, index) => DiaryCardWidget(
          title: diaryItems[index].title,
          content: diaryItems[index].content,
          date: diaryItems[index].createdAt.toString(),
        ),
      ),
    );
  }
}
