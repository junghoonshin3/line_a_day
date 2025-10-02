import 'package:isar_community/isar.dart';

abstract class LocalDb {
  Future<void> initDb();
  Isar getDb();
}
