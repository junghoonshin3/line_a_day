class DiaryWriteState {
  final String text;
  final String currentPrompt;
  final bool isWriting;

  DiaryWriteState({
    this.text = '',
    this.currentPrompt = "오늘 하루는 어땠나요?",
    this.isWriting = false,
  });

  DiaryWriteState copyWith({
    String? text,
    String? currentPrompt,
    bool? isWriting,
  }) {
    return DiaryWriteState(
      text: text ?? this.text,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      isWriting: isWriting ?? this.isWriting,
    );
  }
}
