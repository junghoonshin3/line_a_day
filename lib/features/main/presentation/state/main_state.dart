import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/shared/constants/bottom_tap_name.dart';

class MainState extends BaseState {
  final BottomTapName selectedBottomTap;

  MainState({required this.selectedBottomTap});

  MainState copyWith({BottomTapName? selectedBottomTap}) {
    return MainState(
      selectedBottomTap: selectedBottomTap ?? this.selectedBottomTap,
    );
  }
}
