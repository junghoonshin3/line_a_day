import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/list/diary_list_view_model.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_list_state.dart';
import 'package:line_a_day/widgets/common/staggered_animation/staggered_animation_mixin.dart';
import 'package:line_a_day/widgets/diary/list/diary_card.dart';
import 'package:line_a_day/widgets/diary/list/filter_tabs.dart';
import 'package:line_a_day/widgets/diary/list/stats_cards.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryListView extends ConsumerStatefulWidget {
  const DiaryListView({super.key});

  @override
  ConsumerState<DiaryListView> createState() => _DiaryListViewState();
}

class _DiaryListViewState extends ConsumerState<DiaryListView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryListViewModelProvider);
    final viewModel = ref.read(diaryListViewModelProvider.notifier);

    return Scaffold(
      floatingActionButton: buildAnimatedItem(
        index: 6,
        scaleAnimation: true,
        child: _buildFAB(),
      ),
      backgroundColor: AppTheme.gray50,
      body: CustomScrollView(
        slivers: [
          // 헤더
          _buildHeader(state),

          // 필터 탭
          buildAnimatedSliverBox(
            index: 3,
            child: FilterTabs(
              selectedMood: state.filterMood,
              onMoodSelected: viewModel.filterByMood,
            ),
          ),

          // 달력
          buildAnimatedSliverBox(
            index: 4,
            customSlideOffset: const Offset(0, 40),
            child: _buildCalendar(state, viewModel),
          ),

          // 일기 리스트
          _buildDiaryList(state, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(DiaryListState state) {
    return SliverAppBar(
      expandedHeight: 220,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFadeItem(
                    index: 0,
                    child: const Text(
                      '나의 일기',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  buildFadeItem(
                    index: 1,
                    child: Row(
                      children: [
                        _buildHeaderIcon(Icons.search),
                        const SizedBox(width: 12),
                        _buildHeaderIcon(Icons.settings),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildAnimatedItem(
                index: 2,
                customSlideOffset: const Offset(0, 20),
                child: StatsCards(
                  totalEntries: state.stats.totalEntries,
                  currentStreak: state.stats.currentStreak,
                  recentMood: state.stats.recentMood,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildCalendar(DiaryListState state, DiaryListViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: state.focusedDate,
        selectedDayPredicate: (day) => isSameDay(day, state.selectedDate),
        onDaySelected: (selectedDay, focusedDay) {
          viewModel.selectDate(selectedDay);
          viewModel.setFocusedDate(focusedDay);
        },
        onPageChanged: (focusedDay) {
          viewModel.setFocusedDate(focusedDay);
        },
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          titleTextStyle: AppTheme.titleLarge,
          leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.gray600),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.gray600),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTheme.labelMedium.copyWith(color: AppTheme.gray400),
          weekendStyle: AppTheme.labelMedium.copyWith(color: AppTheme.gray400),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryBlue, width: 2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          selectedTextStyle: AppTheme.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          weekendTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray700,
            fontWeight: FontWeight.w600,
          ),
          outsideTextStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.gray300,
          ),
          markerDecoration: const BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          markerSize: 4,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (viewModel.hasEntryOnDate(date)) {
              return Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDiaryList(DiaryListState state, DiaryListViewModel viewModel) {
    final groupedEntries = viewModel.getGroupedEntries();

    if (groupedEntries.isEmpty) {
      return buildAnimatedSliverBox(index: 5, child: _buildEmptyState());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dateKey = groupedEntries.keys.elementAt(index);
        final entries = groupedEntries[dateKey]!;

        return buildSliverAnimatedItem(
          index: index + 5,
          customSlideOffset: const Offset(0, 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSection(dateKey),
                const SizedBox(height: 12),
                ...entries.asMap().entries.map((entry) {
                  final entity = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DiaryCard(
                      model: entity,
                      onTap: () => _onDiaryTap(entity),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }, childCount: groupedEntries.length),
    );
  }

  Widget _buildDateSection(String dateString) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          dateString,
          style: AppTheme.labelLarge.copyWith(color: AppTheme.gray600),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Text(
            '📝',
            style: TextStyle(
              fontSize: 64,
              color: AppTheme.gray300.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 작성된 일기가 없습니다.\n오늘의 이야기를 기록해보세요!',
            textAlign: TextAlign.center,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.gray400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _onWriteDiary,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 28),
      ),
    );
  }

  void _onDiaryTap(DiaryModel entity) {
    // TODO: 일기 상세 화면으로 이동
    print('일기 탭: ${entity.title}');
  }

  void _onWriteDiary() {
    Navigator.of(context).pushNamed("diaryWrite");
  }
}
