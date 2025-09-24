import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/model/diary_entity.dart';

class HiveHelper {
  static final HiveHelper _singleton = HiveHelper._internal();

  HiveHelper._internal();

  factory HiveHelper() {
    return _singleton;
  }

  initHiveManager() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DiaryEntityAdapter());
    await _openAllBoxes();
  }

  Future<void> _openAllBoxes() {
    return Future.wait([Hive.openBox<DiaryEntity>(diaryBox)]);
  }
}
