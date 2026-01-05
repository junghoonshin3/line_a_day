import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/features/diary/presentation/diary_list/diary_list_view.dart';
import 'package:line_a_day/features/main/presentation/view_model/main_view_model.dart';
import 'package:line_a_day/features/main/presentation/state/main_state.dart';
import 'package:line_a_day/features/emoji/presentation/statistic/diary_statistic_view.dart';
import 'package:line_a_day/features/goal/presentation/goal_view.dart';
import 'package:line_a_day/features/settings/presentation/setting_home/setting_view.dart';
import 'package:line_a_day/shared/constants/bottom_tap_name.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabItem = const [
    DiaryListView(),
    DiaryStatisticView(),
    GoalView(),
    SettingView(),
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

    // 상태 변화 시 탭 전환
    ref.listen<MainState>(mainViewModelProvider, (before, next) {
      if (before?.selectedBottomTap != next.selectedBottomTap) {
        switch (next.selectedBottomTap) {
          case BottomTapName.diary:
            _tabController.animateTo(0);
            break;
          case BottomTapName.statistics:
            _tabController.animateTo(1);
            break;
          case BottomTapName.goal:
            _tabController.animateTo(2);
            break;
          case BottomTapName.myinfo:
            _tabController.animateTo(3);
            break;
        }
      }
    });

    final currentIndex = _bottomTapToIndex(state.selectedBottomTap);

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabItem,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadiusGeometry.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            final selectedTap = _indexToBottomTap(index);
            viewModel.selectedBottomTapName(selectedTap);
          },
          height: 80,
          elevation: 6,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book),
              label: '일기',
            ),
            const NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: '통계',
            ),
            const NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag),
              label: '목표',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: '내정보',
            ),
          ],
        ),
      ),
    );
  }

  int _bottomTapToIndex(BottomTapName name) {
    switch (name) {
      case BottomTapName.diary:
        return 0;
      case BottomTapName.statistics:
        return 1;
      case BottomTapName.goal:
        return 2;
      case BottomTapName.myinfo:
        return 3;
    }
  }

  BottomTapName _indexToBottomTap(int index) {
    switch (index) {
      case 0:
        return BottomTapName.diary;
      case 1:
        return BottomTapName.statistics;
      case 2:
        return BottomTapName.goal;
      case 3:
        return BottomTapName.myinfo;
      default:
        return BottomTapName.diary;
    }
  }
}
