import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

abstract class DiaryRepository {
  Future<void> saveDiary(DiaryModel model);
}
