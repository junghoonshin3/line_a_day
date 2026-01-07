import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/base/base_state.dart';

abstract class BaseViewModel<T extends BaseState> extends StateNotifier<T> {
  BaseViewModel(super.initialState);

  /// 로딩 상태로 변경
  void setLoading(bool isLoading);

  /// 에러 메시지 설정
  void setError(String? message);

  /// 에러 메시지 초기화
  void clearError() => setError(null);
}