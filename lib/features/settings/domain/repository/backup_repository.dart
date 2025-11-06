import 'package:line_a_day/features/settings/domain/model/backup_info.dart';

abstract class BackupRepository {
  /// 구글 드라이브로 백업
  Future<BackupInfo> backupToGoogleDrive();

  /// 로컬 파일로 백업 (사용자가 저장 위치 지정)
  Future<BackupInfo> saveBackupFile();

  /// 앱 내부 저장소에 백업
  Future<BackupInfo> backupToAppInternal();

  /// 백업 히스토리 가져오기
  Future<List<BackupInfo>> getBackupHistory();

  /// 백업 삭제
  Future<void> deleteBackup(BackupInfo backup);

  /// 백업 파일에서 복원 (사용자가 직접 선택한 파일)
  Future<void> restoreFromFile();

  /// 특정 백업 정보로 복원
  Future<void> restoreFromBackup(BackupInfo backupInfo);

  /// 구글 드라이브 로그인 상태 확인
  Future<bool> isGoogleDriveConnected();

  /// 구글 드라이브 로그인
  Future<void> signInToGoogleDrive();

  /// 구글 드라이브 로그아웃
  Future<void> signOutFromGoogleDrive();
}
