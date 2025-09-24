import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/repository/diary_list_repository_impl.dart';

class DiaryListService {
  final DiaryListRepository diaryListRepository;
  DiaryListService({required this.diaryListRepository});

  Future<List<DiaryEntity>> getDiaryItems(DateTime selectedDate) async {
    final list = await diaryListRepository.getDiaryList(selectedDate);
    return list;
  }

  Future<void> addDiaryItem(DiaryEntity entity) async {
    await diaryListRepository.addDiary(entity);
  }
}

final diaryListServiceProvider = Provider((ref) {
  return DiaryListService(
    diaryListRepository: ref.watch(diaryRepositoryProvider),
  );
});
