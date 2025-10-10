enum BottomTapName {
  diary("일기장"),
  statistics("통계"),
  goal("목표"),
  myinfo("내 정보");

  final String description;

  const BottomTapName(this.description);
}

enum MoodType { happy, excited, calm, tired, sad, angry, grateful, anxious }

class Mood {
  final MoodType type;
  final String emoji;
  final String label;
  final int colorCode;

  const Mood({
    required this.type,
    required this.emoji,
    required this.label,
    required this.colorCode,
  });

  static const List<Mood> moods = [
    Mood(
      type: MoodType.happy,
      emoji: '😊',
      label: '기분 좋음',
      colorCode: 0xFFFEF3C7,
    ),
    Mood(
      type: MoodType.excited,
      emoji: '🤩',
      label: '신남',
      colorCode: 0xFFFED7AA,
    ),
    Mood(type: MoodType.calm, emoji: '😌', label: '평온함', colorCode: 0xFFDBEAFE),
    Mood(
      type: MoodType.tired,
      emoji: '😴',
      label: '피곤함',
      colorCode: 0xFFE9D5FF,
    ),
    Mood(type: MoodType.sad, emoji: '😢', label: '슬픔', colorCode: 0xFFF3F4F6),
    Mood(type: MoodType.angry, emoji: '😤', label: '화남', colorCode: 0xFFFECDD3),
    Mood(
      type: MoodType.grateful,
      emoji: '🥰',
      label: '감사함',
      colorCode: 0xFFFCE7F3,
    ),
    Mood(
      type: MoodType.anxious,
      emoji: '😰',
      label: '불안함',
      colorCode: 0xFFE0E7FF,
    ),
  ];

  static Mood? getMoodByType(MoodType type) {
    try {
      return moods.firstWhere((mood) => mood.type == type);
    } catch (e) {
      return null;
    }
  }
}
