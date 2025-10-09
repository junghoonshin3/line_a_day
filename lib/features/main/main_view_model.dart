import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/main/state/main_state.dart';

class MainViewModel extends StateNotifier<MainState> {
  MainViewModel() : super(MainState(selectedBottomTap: BottomTapName.diary));

  void selectedBottomTapName(BottomTapName name) {
    state = state.copyWith(selectedBottomTap: name);
  }
}

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>(
  (ref) => MainViewModel(),
);
