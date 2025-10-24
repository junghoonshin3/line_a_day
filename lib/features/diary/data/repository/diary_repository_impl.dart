import 'package:isar_community/isar.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/mapper/diary_mapper.dart';

class DiaryRepositoryImpl extends DiaryRepository {
  final Isar _isar;

  DiaryRepositoryImpl(this._isar);

  @override
  Future<void> saveDiary(DiaryModel model) async {
    await _isar.writeTxn(() async {
      await _isar.diaryEntitys.put(model.toEntity());
    });
  }

  @override
  Future<void> deleteDiary(int id) async {
    await _isar.writeTxn(() async {
      await _isar.diaryEntitys.delete(id);
    });
  }

  @override
  Stream<List<DiaryModel>> getAllDiaries() {
    try {
      return _isar.diaryEntitys
          .where()
          .sortByCreatedAtDesc()
          .watch(fireImmediately: true)
          .map((entities) => DiaryMapper.toModelList(entities));
    } catch (e) {
      print('일기 불러오기 실패: $e');
      rethrow;
    }
  }

  @override
  Future<List<DiaryModel>> getDiariesByDate(DateTime date) async {
    try {
      // 해당 날짜의 시작과 끝 시간 계산
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final entities = await _isar.diaryEntitys
          .where()
          .filter()
          .createdAtBetween(startOfDay, endOfDay)
          .sortByCreatedAtDesc()
          .findAll();

      return DiaryMapper.toModelList(entities);
    } catch (e) {
      print('날짜별 일기 불러오기 실패: $e');
      rethrow;
    }
  }

  @override
  Stream<DiaryModel?> getDiaryById(int id) {
    try {
      return _isar.diaryEntitys
          .where()
          .idEqualTo(id)
          .watch(fireImmediately: true)
          .map(
            (entities) => entities.isNotEmpty ? entities.first.toModel() : null,
          );
    } catch (e) {
      print('일기 조회 실패: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateDiary(DiaryModel diary) async {
    await _isar.writeTxn(() async {
      if (diary.id == null) {
        throw Exception('수정할 일기의 ID가 없습니다.');
      }

      // lastModified 업데이트
      final updatedDiary = diary.copyWith(lastModified: DateTime.now());
      await _isar.diaryEntitys.put(updatedDiary.toEntity());
    });
  }
}
