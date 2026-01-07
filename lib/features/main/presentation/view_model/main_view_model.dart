import 'package:flutter_riverpod/legacy.dart';

import 'package:line_a_day/features/main/presentation/state/main_state.dart';
import 'package:line_a_day/shared/constants/bottom_tap_name.dart';

class MainViewModel extends StateNotifier<MainState> {
  MainViewModel() : super(MainState(selectedBottomTap: BottomTapName.diary));

  void selectedBottomTapName(BottomTapName name) {
    state = state.copyWith(selectedBottomTap: name);
  }
}

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>(
  (ref) => MainViewModel(),
);
