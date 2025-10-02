class EmojiSelectState {
  final EmojiStyle? selectedStyle;
  final bool isLoading;
  final String? errorMessage;
  final bool isCompleted;

  EmojiSelectState({
    this.selectedStyle,
    this.isLoading = false,
    this.errorMessage,
    this.isCompleted = false,
  });

  EmojiSelectState copyWith({
    EmojiStyle? selectedStyle,
    bool? isLoading,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return EmojiSelectState(
      selectedStyle: selectedStyle ?? this.selectedStyle,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum EmojiStyle { threeD, flat, sketch }

class EmojiStyleData {
  final EmojiStyle style;
  final String label;
  final List<String> images;

  const EmojiStyleData({
    required this.style,
    required this.label,
    required this.images,
  });

  static const String assetsPath = "assets/images";

  static final List<EmojiStyleData> styles = [
    const EmojiStyleData(
      style: EmojiStyle.threeD,
      label: '3D',
      images: [
        "$assetsPath/free_icon_love_1791311.png",
        "$assetsPath/free_icon_smile_1791293.png",
        "$assetsPath/free-icon-sad-1791330.png",
      ],
    ),
    const EmojiStyleData(
      style: EmojiStyle.flat,
      label: '플렛',
      images: [
        "$assetsPath/free_icon_love_1791391.png",
        "$assetsPath/free_icon_smile_1791342.png",
        "$assetsPath/free-icon-sad-1791429.png",
      ],
    ),
    const EmojiStyleData(
      style: EmojiStyle.sketch,
      label: '스케치',
      images: [
        "$assetsPath/free_icon_love_1794777.png",
        "$assetsPath/free_icon_smile_1794767.png",
        "$assetsPath/free-icon-sad-1794787.png",
      ],
    ),
  ];

  static EmojiStyleData? getStyleByType(EmojiStyle style) {
    try {
      return styles.firstWhere((s) => s.style == style);
    } catch (e) {
      return null;
    }
  }
}
