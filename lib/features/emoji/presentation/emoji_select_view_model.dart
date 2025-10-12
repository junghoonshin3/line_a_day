import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/features/emoji/presentation/state/emoji_select_state.dart';

class EmojiSelectViewModel extends StateNotifier<EmojiSelectState> {
  // final AppConfigNotifier appConfigNotifier;

  EmojiSelectViewModel() : super(EmojiSelectState());

  void selectStyle(EmojiStyle style) {
    state = state.copyWith(selectedStyle: style, errorMessage: null);
  }

  void clearSelection() {
    state = state.copyWith(selectedStyle: null, errorMessage: null);
  }

  Future<void> confirmSelection() async {
    if (state.selectedStyle == null) {
      state = state.copyWith(errorMessage: '이모지 스타일을 선택해주세요');
      return;
    }

    try {
      // 여기에 실제 저장 로직 추가 (API 호출, SharedPreferences 저장 등)
      // appConfigNotifier.updateEmojiStyle(state.selectedStyle.toString());

      state = state.copyWith(isLoading: false, isCompleted: true);
      // 선택 완료 상태로 업데이트
    } catch (e) {
      print("e :$e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이모지 스타일 저장 중 오류가 발생했습니다.',
      );
    }
  }

  void resetState() {
    state = EmojiSelectState();
  }

  EmojiStyleData? get selectedStyleData {
    if (state.selectedStyle == null) return null;
    return EmojiStyleData.getStyleByType(state.selectedStyle!);
  }
}
