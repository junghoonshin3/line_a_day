import 'package:line_a_day/features/diary/data/model/diary_model.dart';

abstract class DraftRepository {
  Future<bool> saveDraft(DiaryModel diary);
  DiaryModel loadDraft();
  Future<bool> clearDraft();
  bool hasDraft();
}
