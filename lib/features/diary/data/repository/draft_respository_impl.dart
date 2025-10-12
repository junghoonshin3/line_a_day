import 'dart:convert';

import 'package:line_a_day/core/storage/storage_keys.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/draft_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraftRespositoryImpl implements DraftRepository {
  final SharedPreferences prefs;

  DraftRespositoryImpl(this.prefs);

  @override
  Future<bool> clearDraft() async {
    return prefs.remove(StorageKeys.darftDiary);
  }

  @override
  bool hasDraft() {
    return prefs.containsKey(StorageKeys.darftDiary);
  }

  @override
  DiaryModel loadDraft() {
    String encoded = prefs.getString(StorageKeys.darftDiary)!;
    final map = jsonDecode(encoded);
    return DiaryModel.fromJson(map);
  }

  @override
  Future<bool> saveDraft(DiaryModel diary) async {
    bool isSuccess;
    try {
      final encoded = jsonEncode(diary.toJson());
      isSuccess = await prefs.setString(StorageKeys.darftDiary, encoded);
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }
}
