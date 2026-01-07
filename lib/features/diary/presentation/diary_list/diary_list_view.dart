import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/config/routes.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/diary_list_view_model.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/state/diary_list_state.dart';
import 'package:line_a_day/shared/widgets/calendar/custom_calendar.dart';
import 'package:line_a_day/shared/widgets/empty_state_widget.dart';
import 'package:line_a_day/shared/widgets/animtation/staggered_animation_mixin.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/widgets/diary_card.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/widgets/filter_tabs.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/widgets/stats_cards.dart';

class DiaryListView extends ConsumerStatefulWidget {
  const DiaryListView({super.key});

  @override
  ConsumerState<DiaryListView> createState() => _DiaryListViewState();
}

class _DiaryListViewState extends ConsumerState<DiaryListView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryListViewModelProvider);
    final viewModel = ref.read(diaryListViewModelProvider.notifier);

    // 검색 모드가 활성화되면 포커스
    ref.listen<DiaryListState>(diaryListViewModelProvider, (previous, next) {
      if (next.isSearchMode && !(previous?.isSearchMode ?? false)) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _searchFocusNode.requestFocus();
        });
      }
    });

    return Scaffold(
      floatingActionButton: state.isSearchMode
          ? null
          : buildAnimatedItem(
              index: 6,
              scaleAnimation: true,
              child: _buildFAB(viewModel),
            ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 헤더 (검색 모드에 따라 다르게 표시)
          state.isSearchMode
              ? _buildSearchHeader(state, viewModel)
              : _buildHeader(state, viewModel),

          // 검색 모드가 아닐 때만 필터 탭과 달력 표시
          if (!state.isSearchMode) ...[
            buildAnimatedSliverBox(
              index: 3,
              child: FilterTabs(
                selectedMood: state.filterMood,
                onMoodSelected: viewModel.filterByMood,
              ),
            ),
            buildAnimatedSliverBox(
              index: 4,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: viewModel.toggleCalendar,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isCalendarExpanded ? '달력 접기' : '달력 펼치기',
                            style: AppTheme.labelLarge.copyWith(
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: state.isCalendarExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildCalendar(state, viewModel),
                ],
              ),
            ),
          ],

          // 일기 리스트
          _buildDiaryList(state, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(DiaryListState state, DiaryListViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 220,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
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
                        _buildHeaderIcon(Icons.search, () {
                          viewModel.toggleSearchMode();
                        }),
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
                  recentEmotion: state.stats.recentEmotion,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(
    DiaryListState state,
    DiaryListViewModel viewModel,
  ) {
    return SliverAppBar(
      expandedHeight: 180, // 높이 조정
      backgroundColor: AppTheme.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      viewModel.toggleSearchMode();
                      _searchController.clear();
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '일기 검색',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 검색창
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: viewModel.updateSearchQuery,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '제목, 내용, 태그로 검색',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            viewModel.clearSearch();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCalendar(DiaryListState state, DiaryListViewModel viewModel) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      child: ClipRect(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: state.isCalendarExpanded ? 1.0 : 0.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: state.isCalendarExpanded ? null : 0,
            child: state.isCalendarExpanded
                ? CalendarWidget(
                    focusedDate: state.focusedDate,
                    selectedDate: state.selectedDate,
                    onDaySelected: (selectedDay, focusedDay) {
                      viewModel.selectDate(selectedDay);
                      viewModel.setFocusedDate(focusedDay);
                    },
                    onPageChanged: (focusedDay) {
                      viewModel.setFocusedDate(focusedDay);
                    },
                    hasEntryOnDate: (date) => viewModel.hasEntryOnDate(date),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildDiaryList(DiaryListState state, DiaryListViewModel viewModel) {
    final selectedEntries = viewModel.getGroupedEntries();

    // 검색 모드이고 검색어가 없는 경우
    if (state.isSearchMode && state.searchQuery.isEmpty) {
      return buildAnimatedSliverBox(
        index: 5,
        child: const EmptyStateWidget(
          icon: Icons.search,
          message: '제목, 내용, 태그로\n일기를 검색해보세요',
        ),
      );
    }

    // 검색 결과가 없는 경우
    if (selectedEntries.isEmpty) {
      return buildAnimatedSliverBox(
        index: 5,
        child: state.isSearchMode
            ? const SearchEmptyWidget()
            : const EmptyStateWidget(
                icon: Icons.edit_note,
                message: '아직 작성된 일기가 없습니다.\n오늘의 이야기를 기록해보세요!',
              ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dateKey = selectedEntries.keys.elementAt(index);
        final entries = selectedEntries[dateKey]!;

        return buildSliverAnimatedItem(
          index: index + 5,
          customSlideOffset: const Offset(0, 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
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
      }, childCount: selectedEntries.length),
    );
  }

  Widget _buildDateSection(String dateString) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
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

  Widget _buildFAB(DiaryListViewModel viewModel) {
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

  void _onDiaryTap(DiaryModel entity) async {
    if (entity.id == null) return;
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.diaryDetail, arguments: entity.id);
  }

  void _onWriteDiary() {
    Navigator.of(context).pushNamed(AppRoutes.diaryWrite);
  }
}
