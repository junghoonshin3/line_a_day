import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/di/di.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_write_repository.dart';
import 'package:line_a_day/features/diary/mapper/diary_mapper.dart';

class DiaryWriteRepositoryImpl implements DiaryWriteRepository {
  final Isar isar;

  DiaryWriteRepositoryImpl(this.isar);

  @override
  Future<void> saveDiary(DiaryModel model) async {
    await isar.writeTxn(() async {
      await isar.diaryEntitys.put(model.toEntity());
    });
  }

  @override
  Future<void> saveDraft(DiaryModel model) async {
    // SharedPreferences나 별도 테이블에 임시 저장
    // 여기서는 간단히 Isar에 draft 플래그와 함께 저장

    await isar.writeTxn(() async {
      await isar.diaryEntitys.put(model.toEntity());
    });
  }

  @override
  Future<DiaryEntity?> loadDraft() async {
    return null;
  }

  MoodType _parseMoodType(String? mood) {
    if (mood == null) return MoodType.happy;
    return MoodType.values.firstWhere(
      (e) => e.name == mood,
      orElse: () => MoodType.happy,
    );
  }
}

// Provider
final diaryWriteRepositoryProvider = Provider<DiaryWriteRepository>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return DiaryWriteRepositoryImpl(db.getDb());
});
