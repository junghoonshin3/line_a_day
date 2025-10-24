import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/diary/presentation/list/diary_list_view.dart';
import 'package:line_a_day/features/diary/presentation/main_view_model.dart';
import 'package:line_a_day/features/diary/presentation/state/main_state.dart';
import 'package:line_a_day/features/emoji/presentation/statistic/presentation/emoji_statistic_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends ConsumerState<MainView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabItem = [
    const DiaryListView(),
    const EmojiStatisticView(),
    const DiaryListView(),
    const DiaryListView(),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabItem.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainViewModelProvider);
    final viewModel = ref.read(mainViewModelProvider.notifier);

    ref.listen<MainState>(mainViewModelProvider, (before, next) {
      if (before?.selectedBottomTap != next.selectedBottomTap) {
        switch (next.selectedBottomTap) {
          case BottomTapName.diary:
            _tabController.animateTo(0);
            return;
          case BottomTapName.statistics:
            _tabController.animateTo(1);
            return;
          case BottomTapName.goal:
            _tabController.animateTo(2);
            return;
          case BottomTapName.myinfo:
            _tabController.animateTo(3);
            return;
        }
      }
    });

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabItem,
      ),

      bottomNavigationBar: _buildBottomNav(
        state: state,
        onTap: (name) {
          viewModel.selectedBottomTapName(name);
        },
      ),
    );
  }

  Widget _buildBottomNav({
    required MainState state,
    required Function(BottomTapName name) onTap,
  }) {
    print("_buildBottomNav : ${state.selectedBottomTap}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.book,
              BottomTapName.diary,
              state.selectedBottomTap == BottomTapName.diary,
              () {
                onTap(BottomTapName.diary);
              },
            ),
            _buildNavItem(
              Icons.bar_chart,
              BottomTapName.statistics,
              state.selectedBottomTap == BottomTapName.statistics,
              () {
                onTap(BottomTapName.statistics);
              },
            ),
            _buildNavItem(
              Icons.flag,
              BottomTapName.goal,
              state.selectedBottomTap == BottomTapName.goal,
              () {
                onTap(BottomTapName.goal);
              },
            ),
            _buildNavItem(
              Icons.person,
              BottomTapName.myinfo,
              state.selectedBottomTap == BottomTapName.myinfo,
              () {
                onTap(BottomTapName.myinfo);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    BottomTapName name,
    bool isActive,
    void Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppTheme.primaryBlue : AppTheme.gray400,
            ),
            const SizedBox(height: 4),
            Text(
              name.description,
              style: AppTheme.labelMedium.copyWith(
                color: isActive ? AppTheme.primaryBlue : AppTheme.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigationBarTab(BottomTapName name) {}
}
