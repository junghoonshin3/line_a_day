import 'package:isar_community/isar.dart';
import 'package:line_a_day/core/database/diary_entity.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static Isar? _isar;

  /// Isar 인스턴스 초기화
  static Future<Isar> initialize() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        DiaryEntitySchema,
        // 다른 Schema들도 여기에 추가
      ],
      directory: dir.path,
      inspector: true, // 개발 중에만 true (디버깅용)
      name: 'line_a_day', // DB 이름
    );

    return _isar!;
  }

  /// Isar 인스턴스 가져오기
  static Isar get instance {
    if (_isar == null) {
      throw Exception(
        'Isar not initialized. Call IsarService.initialize() first.',
      );
    }
    return _isar!;
  }

  /// Isar 닫기 (앱 종료 시)
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
