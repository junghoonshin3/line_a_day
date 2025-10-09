import 'package:isar_community/isar.dart';
import 'package:line_a_day/model/mood.dart';
part 'diary_entity.g.dart';

@collection
class DiaryEntity {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late DateTime createdAt;
  late String title;
  late String content;
  @enumerated
  late MoodType mood;
  List<String>? tags;
  String? weather;
  String? location;
}

// 저장
// await isar.writeTxn(() async {
//   await isar.diaryEntrys.put(entry);
// });

// // 쿼리
// final entries = await isar.diaryEntrys
//   .filter()
//   .moodEqualTo(MoodType.happy)
//   .sortByDateDesc()
//   .findAll();
