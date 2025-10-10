import 'package:isar_community/isar.dart';
import 'package:line_a_day/core/db/local_db.dart';
import 'package:line_a_day/features/diary/data/model/diary_entity.dart';
import 'package:path_provider/path_provider.dart';

interface class LocalDbImpl extends LocalDb {
  late Isar db;

  @override
  Isar getDb() {
    return db;
  }

  @override
  Future<void> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open([DiaryEntitySchema], directory: dir.path);
  }
}
