class DiaryListState {
  final bool isLoading;

  DiaryListState({this.isLoading = false});

  DiaryListState copyWith({bool? isLoading}) {
    return DiaryListState(isLoading: isLoading ?? this.isLoading);
  }
}
