class DiaryWriteState {
  bool isLoading = false;
  String? errorMessage;

  DiaryWriteState({this.isLoading = false, this.errorMessage});

  DiaryWriteState copyWith({bool? isLoading, String? errorMessage}) {
    return DiaryWriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
