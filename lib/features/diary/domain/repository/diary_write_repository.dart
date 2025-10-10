import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

abstract class DiaryWriteRepository {
  Future<void> saveDiary(DiaryModel model);
  Future<void> saveDraft(DiaryModel model);
  Future<DiaryEntity?> loadDraft();
}
