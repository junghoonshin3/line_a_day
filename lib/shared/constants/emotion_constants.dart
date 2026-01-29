enum EmotionType {
  happy,
  excited,
  calm,
  tired,
  sad,
  angry,
  grateful,
  anxious,
  lonely,
  proud,
  bored,
  hopeful,
}

class Emotion {
  final EmotionType type;
  final String emoji;
  final String label;
  final int colorCode;

  const Emotion({
    required this.type,
    required this.emoji,
    required this.label,
    required this.colorCode,
  });

  static const List<Emotion> emotions = [
    Emotion(
      type: EmotionType.happy,
      emoji: '😊',
      label: '기분 좋음',
      colorCode: 0xFFFEF3C7,
    ),
    Emotion(
      type: EmotionType.excited,
      emoji: '🤩',
      label: '신남',
      colorCode: 0xFFFED7AA,
    ),
    Emotion(
      type: EmotionType.calm,
      emoji: '😌',
      label: '평온함',
      colorCode: 0xFFDBEAFE,
    ),
    Emotion(
      type: EmotionType.tired,
      emoji: '😴',
      label: '피곤함',
      colorCode: 0xFFE9D5FF,
    ),
    Emotion(
      type: EmotionType.sad,
      emoji: '😢',
      label: '슬픔',
      colorCode: 0x3B5BDBFF,
    ),
    Emotion(
      type: EmotionType.angry,
      emoji: '😤',
      label: '화남',
      colorCode: 0xFFFECDD3,
    ),
    Emotion(
      type: EmotionType.grateful,
      emoji: '🥰',
      label: '감사함',
      colorCode: 0xFFFCE7F3,
    ),
    Emotion(
      type: EmotionType.anxious,
      emoji: '😰',
      label: '불안함',
      colorCode: 0xFFE0E7FF,
    ),
    Emotion(
      type: EmotionType.lonely,
      emoji: '😔',
      label: '외로움',
      colorCode: 0xFFDDD6FE,
    ),
    Emotion(
      type: EmotionType.proud,
      emoji: '😎',
      label: '뿌듯함',
      colorCode: 0xFFBFDBFE,
    ),
    Emotion(
      type: EmotionType.bored,
      emoji: '😑',
      label: '지루함',
      colorCode: 0xFFD1D5DB,
    ),
    Emotion(
      type: EmotionType.hopeful,
      emoji: '🌟',
      label: '희망참',
      colorCode: 0xFFFDE68A,
    ),
  ];

  static Emotion? getMoodByType(EmotionType type) {
    try {
      return emotions.firstWhere((mood) => mood.type == type);
    } catch (e) {
      return null;
    }
  }
}
