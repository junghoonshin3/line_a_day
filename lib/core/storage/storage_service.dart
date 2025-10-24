import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// core/storage/storage_service.dart
// SharedPreferences 초기화 및 관리 서비스
// ═══════════════════════════════════════════════════════════════
class StorageService {
  static SharedPreferences? _prefs;

  /// SharedPreferences 초기화
  static Future<SharedPreferences> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// SharedPreferences 인스턴스 가져오기
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferences not initialized. Call StorageService.initialize() first.',
      );
    }
    return _prefs!;
  }

  /// 모든 데이터 삭제
  static Future<bool> clearAll() async {
    return await instance.clear();
  }
}
