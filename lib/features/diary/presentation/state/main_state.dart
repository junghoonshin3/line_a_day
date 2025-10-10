import 'package:line_a_day/constant.dart';

class MainState {
  final BottomTapName selectedBottomTap;

  MainState({required this.selectedBottomTap});

  MainState copyWith({BottomTapName? selectedBottomTap}) {
    return MainState(
      selectedBottomTap: selectedBottomTap ?? this.selectedBottomTap,
    );
  }
}
