import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/model/diary_entity.dart';

class DiaryListRepositoryImpl extends DiaryListRepository {
  final Box<DiaryEntity> box;
  DiaryListRepositoryImpl(this.box);

  @override
  Future<void> addDiary(DiaryEntity entity) async {
    await box.add(entity);
  }

  @override
  Future<List<DiaryEntity>> getDiaryList(DateTime selectedDate) async {
    return box.values
        .where(
          (item) =>
              item.date.year == selectedDate.year &&
              item.date.day == selectedDate.day &&
              item.date.month == selectedDate.month,
        )
        .map((item) => item)
        .toList();
  }

  @override
  Future<void> modifyDiary(dynamic key, String? title, String? content) async {
    final diary = box.get(key);
    if (diary != null) {
      final updatedDiary = diary.copyWith(title: title, content: content);
      await box.put(key, updatedDiary);
    }
  }

  @override
  Future<void> removeDiary(dynamic key) async {
    await box.delete(key);
  }
}

// Provider
final diaryRepositoryProvider = Provider<DiaryListRepository>((ref) {
  return DiaryListRepositoryImpl(ref.watch(diaryBoxProvider));
});

final diaryBoxProvider = Provider<Box<DiaryEntity>>((_) {
  return Hive.box<DiaryEntity>(diaryBox);
});

abstract class DiaryListRepository {
  Future<List<DiaryEntity>> getDiaryList(DateTime date);

  Future<void> addDiary(DiaryEntity entity);

  Future<void> removeDiary(dynamic key);

  Future<void> modifyDiary(dynamic key, String? title, String? content);
}
