import 'package:isar_community/isar.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';

part 'diary_entity.g.dart';

@collection
class DiaryEntity {
  Id id = Isar.autoIncrement;
  @Index()
  late DateTime createdAt;
  late String title;
  late String content;
  @enumerated
  late EmotionType emotionType;
  List<String>? tags; // ['친구', '행복', '여행']
  List<String>? photoUrls; // ['path/to/photo1.jpg', ...]

  /*
  단순 문자열 (nullable)
  - 선택적으로 입력
  */
  String? weather; // '☀️ 맑음'
  String? location; // '강남역'

  /*
  bool 타입 (기본값 지정)
  - late 없이 바로 초기화
  - 즐겨찾기 기능용
  */
  bool isFavorite = false;

  /*
  @Index() + nullable DateTime
  - 마지막 수정 시간
  - 정렬이나 동기화에 사용
  */
  @Index()
  DateTime? lastModified;
}
