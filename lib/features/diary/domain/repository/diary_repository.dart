import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

abstract class DiaryRepository {
  /// 모든 일기 조회(Stream)
  Stream<List<DiaryModel>> getAllDiariesForRealtime();

  /// 특정 일기 조회
  Stream<DiaryModel?> getDiaryById(int id);

  /// 날짜별 일기 조회
  Future<List<DiaryModel>> getDiariesByDate(DateTime date);

  /// 일기 저장
  Future<void> saveDiary(DiaryModel diary);

  /// 일기 업데이트
  Future<void> updateDiary(DiaryModel diary);

  /// 일기 삭제
  Future<void> deleteDiary(int id);

  //모든 일기 조회
  Future<List<DiaryModel>> getAllDiaries();

  //범위에 속한 모든 일기 조회
  Future<List<DiaryModel>> getDiariesByRange(
    DateTime startDate,
    DateTime endDate,
  );
}
