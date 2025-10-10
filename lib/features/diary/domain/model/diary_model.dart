import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/emoji/presentation/state/emoji_select_state.dart';

class DiaryModel {
  final int? id;
  final DateTime createdAt;
  final String title;
  final String content;
  final MoodType mood;
  final EmojiStyle? emojiStyle;
  final List<String> tags;
  final List<String> photoUrls;
  final String? weather;
  final String? location;
  final bool isFavorite;
  final DateTime? lastModified;

  DiaryModel({
    this.id,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.mood,
    this.emojiStyle,
    this.tags = const [],
    this.photoUrls = const [],
    this.weather,
    this.location,
    this.isFavorite = false,
    this.lastModified,
  });

  // copyWith — 값 일부만 수정해서 새 객체 생성할 때 유용
  DiaryModel copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? content,
    MoodType? mood,
    EmojiStyle? emojiStyle,
    List<String>? tags,
    List<String>? photoUrls,
    String? weather,
    String? location,
    bool? isFavorite,
    DateTime? lastModified,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      emojiStyle: emojiStyle ?? this.emojiStyle,
      tags: tags ?? this.tags,
      photoUrls: photoUrls ?? this.photoUrls,
      weather: weather ?? this.weather,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}
