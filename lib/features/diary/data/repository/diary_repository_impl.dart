import 'package:isar_community/isar.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/mapper/diary_mapper.dart';

class DiaryRepositoryImpl extends DiaryRepository {
  final Isar isar;

  DiaryRepositoryImpl(this.isar);

  @override
  Future<void> saveDiary(DiaryModel model) async {
    await isar.writeTxn(() async {
      await isar.diaryEntitys.put(model.toEntity());
    });
  }

  MoodType _parseMoodType(String? mood) {
    if (mood == null) return MoodType.happy;
    return MoodType.values.firstWhere(
      (e) => e.name == mood,
      orElse: () => MoodType.happy,
    );
  }
}
