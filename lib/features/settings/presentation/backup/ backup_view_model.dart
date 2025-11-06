import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/features/settings/domain/model/backup_info.dart';
import 'package:line_a_day/features/settings/domain/repository/backup_repository.dart';
import 'package:line_a_day/features/settings/presentation/backup/state/backup_state.dart';

class BackupViewModel extends StateNotifier<BackupState> {
  final BackupRepository _repository;

  BackupViewModel(this._repository) : super(BackupState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final isConnected = await _repository.isGoogleDriveConnected();
      final history = await _repository.getBackupHistory();
      state = state.copyWith(
        isGoogleDriveConnected: isConnected,
        backupHistory: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '초기화 실패: $e');
    }
  }

  /// 구글 드라이브 백업
  Future<void> backupToGoogleDrive() async {
    state = state.copyWith(isLoading: true);

    try {
      if (!state.isGoogleDriveConnected) {
        await _repository.signInToGoogleDrive();
        state = state.copyWith(isGoogleDriveConnected: true);
      }

      final backupInfo = await _repository.backupToGoogleDrive();
      final updatedHistory = [backupInfo, ...state.backupHistory];

      state = state.copyWith(
        isLoading: false,
        backupHistory: updatedHistory,
        lastBackup: backupInfo,
        successMessage: '구글 드라이브 백업 완료',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '구글 드라이브 백업 실패: $e',
      );
    }
  }

  /// 파일로 저장 (사용자가 위치 선택)
  Future<void> saveBackupFile() async {
    state = state.copyWith(isLoading: true);

    try {
      final backupInfo = await _repository.saveBackupFile();
      final updatedHistory = [backupInfo, ...state.backupHistory];

      state = state.copyWith(
        isLoading: false,
        backupHistory: updatedHistory,
        lastBackup: backupInfo,
        successMessage: '백업 파일 저장 완료',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('선택하지 않았습니다')
            ? null // 취소한 경우 에러 표시 안 함
            : '파일 저장 실패: $e',
      );
    }
  }

  /// 파일에서 복원 (사용자가 파일 선택)
  Future<void> restoreFromFile() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.restoreFromFile();

      state = state.copyWith(isLoading: false, successMessage: '백업 파일 복원 완료');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('선택하지 않았습니다')
            ? null // 취소한 경우 에러 표시 안 함
            : '파일 복원 실패: $e',
      );
    }
  }

  /// 앱 내 백업
  Future<void> backupToAppInternal() async {
    state = state.copyWith(isLoading: true);

    try {
      final backupInfo = await _repository.backupToAppInternal();
      final updatedHistory = [backupInfo, ...state.backupHistory];

      state = state.copyWith(
        isLoading: false,
        backupHistory: updatedHistory,
        lastBackup: backupInfo,
        successMessage: '앱 내 백업 완료',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '앱 내 백업 실패: $e');
    }
  }

  /// 백업 복원
  Future<void> restoreFromBackup(BackupInfo backupInfo) async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.restoreFromBackup(backupInfo);

      state = state.copyWith(
        isLoading: false,
        successMessage: '백업 복원 완료 (${backupInfo.diaryCount}개의 일기)',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '백업 복원 실패: $e');
    }
  }

  /// 백업 삭제
  Future<void> deleteBackup(BackupInfo backup) async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.deleteBackup(backup);

      final newHistory = await _repository.getBackupHistory();

      state = state.copyWith(
        isLoading: false,
        backupHistory: newHistory,
        successMessage: '백업 삭제 완료',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '백업 삭제 실패: $e');
    }
  }

  /// 구글 드라이브 로그인
  Future<void> signInToGoogleDrive() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.signInToGoogleDrive();

      state = state.copyWith(
        isLoading: false,
        isGoogleDriveConnected: true,
        successMessage: '구글 드라이브 연결 완료',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '구글 드라이브 연결 실패: $e',
      );
    }
  }

  /// 구글 드라이브 로그아웃
  Future<void> signOutFromGoogleDrive() async {
    try {
      await _repository.signOutFromGoogleDrive();

      state = state.copyWith(
        isGoogleDriveConnected: false,
        successMessage: '구글 드라이브 연결 해제',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: '구글 드라이브 연결 해제 실패: $e');
    }
  }

  /// 백업 히스토리 새로고침
  Future<void> refreshHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final history = await _repository.getBackupHistory();
      state = state.copyWith(backupHistory: history, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: '히스토리 새로고침 실패: $e',
        isLoading: false,
      );
    }
  }

  /// 메시지 초기화
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
