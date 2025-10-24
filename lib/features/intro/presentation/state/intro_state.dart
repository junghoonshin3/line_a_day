class IntroState {
  final int currentPage;
  final bool isCompleted;

  IntroState({this.currentPage = 0, this.isCompleted = false});

  IntroState copyWith({int? currentPage, bool? isCompleted}) {
    return IntroState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
