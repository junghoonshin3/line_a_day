class DiaryWriteState {
  final String text;
  final String title;
  final String currentPrompt;
  final bool isWriting;
  final bool emojiShowing;

  DiaryWriteState({
    this.text = "",
    this.title = "",
    this.currentPrompt = "오늘 하루는 어땠나요?",
    this.isWriting = false,
    this.emojiShowing = false,
  });

  DiaryWriteState copyWith({
    String? text,
    String? title,
    String? currentPrompt,
    bool? isWriting,
    bool? emojiShowing,
  }) {
    return DiaryWriteState(
      text: text ?? this.text,
      title: title ?? this.title,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      isWriting: isWriting ?? this.isWriting,
      emojiShowing: emojiShowing ?? this.emojiShowing,
    );
  }
}
