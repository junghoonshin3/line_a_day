import 'dart:ui';

enum BottomTapName {
  diary("일기장"),
  statistics("통계"),
  goal("목표"),
  myinfo("내 정보");

  final String description;

  const BottomTapName(this.description);
}

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
      colorCode: 0xFFF3F4F6,
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

class WeatherData {
  final String icon;
  final String name;
  final String value;
  final Color color;

  const WeatherData({
    required this.icon,
    required this.name,
    required this.value,
    required this.color,
  });

  static const List<WeatherData> weathers = [
    WeatherData(
      icon: '☀️',
      name: '맑음',
      value: 'sunny',
      color: Color(0xFFFDB813),
    ),
    WeatherData(
      icon: '⛅',
      name: '구름 조금',
      value: 'partly_cloudy',
      color: Color(0xFF93C5FD),
    ),
    WeatherData(
      icon: '☁️',
      name: '흐림',
      value: 'cloudy',
      color: Color(0xFF9CA3AF),
    ),
    WeatherData(
      icon: '🌧️',
      name: '비',
      value: 'rainy',
      color: Color(0xFF60A5FA),
    ),
    WeatherData(
      icon: '⛈️',
      name: '천둥번개',
      value: 'thunderstorm',
      color: Color(0xFF6366F1),
    ),
    WeatherData(
      icon: '❄️',
      name: '눈',
      value: 'snowy',
      color: Color(0xFFBFDBFE),
    ),
    WeatherData(
      icon: '🌫️',
      name: '안개',
      value: 'foggy',
      color: Color(0xFFD1D5DB),
    ),
    WeatherData(
      icon: '🌪️',
      name: '바람',
      value: 'windy',
      color: Color(0xFF94A3B8),
    ),
  ];

  static WeatherData? getWeatherByValue(String? value) {
    if (value == null) return null;
    try {
      return weathers.firstWhere((weather) => weather.value == value);
    } catch (e) {
      return null;
    }
  }
}
