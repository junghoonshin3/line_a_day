import 'package:hive_flutter/hive_flutter.dart';
part 'diary_entity.g.dart';

@HiveType(typeId: 0)
class DiaryEntity extends HiveObject {
  @HiveField(0)
  String id; // UUID 또는 고유 식별자

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime date; // 일기 작성 날짜 (년-월-일)

  @HiveField(4)
  DateTime createdAt; // 생성 시간

  @HiveField(5)
  DateTime updatedAt; // 수정 시간

  @HiveField(6)
  int? moodScore; // 기분 점수 (1-5)

  @HiveField(7)
  String? weather; // 날씨 정보

  @HiveField(8)
  bool isFavorite; // 즐겨찾기 여부

  @HiveField(9)
  bool isPrivate; // 비공개 여부

  @HiveField(10)
  final List<String> tags; // 태그 목록

  @HiveField(11)
  final List<String> imageUrls; // 첨부 이미지 경로들

  DiaryEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.moodScore = 1,
    this.weather = "",
    this.isFavorite = false,
    this.isPrivate = false,
    this.tags = const [],
    this.imageUrls = const [],
  });

  // 복사 생성자 (수정 시 사용)
  DiaryEntity copyWith({
    String? title,
    String? content,
    DateTime? date,
    int? moodScore,
    String? weather,
    bool? isFavorite,
    bool? isPrivate,
    List<String>? tags,
    String? location,
    List<String>? imageUrls,
  }) {
    return DiaryEntity(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      moodScore: moodScore ?? this.moodScore,
      weather: weather ?? this.weather,
      isFavorite: isFavorite ?? this.isFavorite,
      isPrivate: isPrivate ?? this.isPrivate,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
