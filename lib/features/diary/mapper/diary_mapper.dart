import 'package:isar_community/isar.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

extension DiaryEntityMapper on DiaryEntity {
  DiaryModel toModel() => DiaryModel(
    id: id,
    createdAt: createdAt,
    title: title,
    content: content,
    emotion: emotionType,
    tags: tags ?? [],
    photoUrls: photoUrls ?? [],
    weather: WeatherData.getWeatherByValue(weather),
    location: location,
    isFavorite: isFavorite,
    lastModified: lastModified,
  );
}

extension DiaryModelMapper on DiaryModel {
  DiaryEntity toEntity() => DiaryEntity()
    ..id = id ?? Isar.autoIncrement
    ..createdAt = createdAt
    ..title = title
    ..content = content
    ..emotionType = emotion
    ..tags = tags
    ..photoUrls = photoUrls
    ..weather = weather?.value
    ..location = location
    ..isFavorite = isFavorite
    ..lastModified = lastModified;
}

class DiaryMapper {
  static List<DiaryModel> toModelList(List<DiaryEntity> entities) {
    return entities.map((entity) => entity.toModel()).toList();
  }

  static List<DiaryEntity> toEntityList(List<DiaryModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
