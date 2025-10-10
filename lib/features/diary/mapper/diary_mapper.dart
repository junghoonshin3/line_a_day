import 'package:isar_community/isar.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

extension DiaryEntityMapper on DiaryEntity {
  DiaryModel toDomain() => DiaryModel(
    id: id,
    createdAt: createdAt,
    title: title,
    content: content,
    mood: mood,
    tags: tags ?? [],
    photoUrls: photoUrls ?? [],
    weather: weather,
    location: location,
    isFavorite: isFavorite,
    lastModified: lastModified,
  );
}

extension DiaryMapper on DiaryModel {
  DiaryEntity toEntity() => DiaryEntity()
    ..id = id ?? Isar.autoIncrement
    ..createdAt = createdAt
    ..title = title
    ..content = content
    ..mood = mood
    ..tags = tags
    ..photoUrls = photoUrls
    ..weather = weather
    ..location = location
    ..isFavorite = isFavorite
    ..lastModified = lastModified;
}
