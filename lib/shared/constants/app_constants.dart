class AppConstants {
  AppConstants._();

  /// 앱 정보
  static const String appName = 'Line A Day';
  static const String appVersion = '1.0.0';
  static const String appDeveloper = 'Line A Day Team';
  static const String appDescription = '매일의 감정을 기록하고\n소중한 추억을 남기세요';

  /// 연락처
  static const String supportEmail = 'support@lineaday.com';

  /// 날짜 포맷
  static const String dateFormat = 'yyyy년 MM월 dd일';
  static const String timeFormat = 'a h:mm';
  static const String dateTimeFormat = 'yyyy.MM.dd HH:mm';

  /// 페이지 크기
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// 이미지
  static const int maxImageSize = 1920; // 픽셀
  static const int imageQuality = 85; // 퍼센트
  static const int maxImagesPerDiary = 10;

  /// 텍스트 길이 제한
  static const int maxTitleLength = 100;
  static const int maxContentLength = 10000;
  static const int maxTagLength = 20;
  static const int maxTagCount = 10;
  static const int maxLocationLength = 100;

  /// 비밀번호
  static const int minPasswordLength = 4;
  static const int maxPasswordLength = 20;
  static const int maxFailedAttempts = 5;
  static const int lockDurationMinutes = 5;

  /// 백업
  static const String backupFileExtension = '.zip';
  static const String backupFolderName = 'LineADay_Backups';
  static const int maxBackupFileSize = 100 * 1024 * 1024; // 100MB

  /// 알림
  static const String notificationChannelId = 'daily_reminder';
  static const String notificationChannelName = '일기 작성 알림';
  static const String notificationChannelDescription = '매일 일기 작성을 알려드립니다';

  /// 통계
  static const int statisticsMinDiaryCount = 1;
  static const int streakCalculationDays = 365;

  /// 애니메이션
  static const int defaultAnimationDuration = 300;
  static const int longAnimationDuration = 600;
  static const int shortAnimationDuration = 150;
}

/// 하단 내비게이션 탭
enum BottomNavTab {
  diary('일기장'),
  statistics('통계'),
  goal('목표'),
  settings('내 정보');

  final String label;
  const BottomNavTab(this.label);
}
