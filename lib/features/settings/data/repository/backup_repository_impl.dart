// lib/features/settings/data/repository/backup_repository_impl.dart

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:line_a_day/core/services/backup_service.dart';
import 'package:line_a_day/core/services/google_drive_service.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/settings/domain/model/backup_info.dart';
import 'package:line_a_day/features/settings/domain/repository/backup_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BackupRepositoryImpl implements BackupRepository {
  final DiaryRepository _diaryRepository;
  final GoogleDriveService _driveService;
  final BackupService _backupService;

  BackupRepositoryImpl({
    required DiaryRepository diaryRepository,
    required GoogleDriveService driveService,
    required BackupService backupService,
  }) : _diaryRepository = diaryRepository,
       _driveService = driveService,
       _backupService = backupService;

  @override
  Future<BackupInfo> backupToGoogleDrive() async {
    try {
      // 모든 일기 가져오기
      final diaries = await _diaryRepository.getAllDiaries();

      // 백업 파일 생성 (이미지 포함)
      final backupFile = await _backupService.createIsarBackupWithImages();
      final stat = await backupFile.stat();

      // 구글 드라이브에 업로드
      final folderId = await _driveService.getOrCreateAppFolder();
      final fileName =
          'LineADay_Backup_${DateTime.now().millisecondsSinceEpoch}.zip';

      final fileId = await _driveService.uploadFile(
        file: backupFile,
        fileName: fileName,
        folderId: folderId,
      );

      // 임시 파일 삭제
      await backupFile.delete();

      // 백업 정보 생성
      final backupInfo = BackupInfo(
        id: fileId,
        createdAt: DateTime.now(),
        type: BackupType.googleDrive,
        location: 'Google Drive: $fileName',
        diaryCount: diaries.length,
        fileSize: stat.size,
        status: BackupStatus.completed,
      );

      // 히스토리에 저장
      await _saveBackupHistory(backupInfo);

      return backupInfo;
    } catch (e) {
      throw Exception('구글 드라이브 백업 실패: $e');
    }
  }

  @override
  Future<BackupInfo> saveBackupFile() async {
    try {
      // 모든 일기 가져오기
      final diaries = await _diaryRepository.getAllDiaries();

      // 백업 파일 생성 (이미지 포함)
      final backupFile = await _backupService.createIsarBackupWithImages();
      final backupBytes = await backupFile.readAsBytes();
      final stat = await backupFile.stat();

      // 파일 저장 위치 선택
      final fileName =
          'LineADay_Backup_${DateTime.now().millisecondsSinceEpoch}.zip';
      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: '백업 파일 저장',
        fileName: fileName,
        bytes: backupBytes,
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      // 임시 파일 삭제
      await backupFile.delete();

      if (outputPath == null) {
        throw Exception('저장 위치를 선택하지 않았습니다');
      }

      // 백업 정보 생성
      final backupInfo = BackupInfo(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        type: BackupType.localFile,
        location: outputPath,
        diaryCount: diaries.length,
        fileSize: stat.size,
        status: BackupStatus.completed,
        canRestore: false, // 파일로 저장한 것은 별도 복원 메뉴 사용
      );

      // 히스토리에 저장
      await _saveBackupHistory(backupInfo);

      return backupInfo;
    } catch (e) {
      throw Exception('파일 저장 실패: $e');
    }
  }

  @override
  Future<void> restoreFromFile() async {
    try {
      // 1. 사용자가 백업 파일 선택
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '복원할 백업 파일 선택',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('파일을 선택하지 않았습니다');
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('파일 경로를 가져올 수 없습니다');
      }

      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        throw Exception('선택한 파일을 찾을 수 없습니다');
      }

      // 2. 백업 파일 검증
      final isValid = await _backupService.validateBackupFile(backupFile);
      if (!isValid) {
        throw Exception('올바른 백업 파일이 아닙니다');
      }

      // 3. 백업 파일에서 데이터 추출 (이미지 포함)
      final diaries = await _backupService.extractBackupDataWithImages(
        backupFile,
      );

      // 4. 기존 데이터 모두 삭제
      await _backupService.clearAllData();

      // 5. 복원된 데이터 저장
      for (final diary in diaries) {
        await _diaryRepository.saveDiary(diary);
      }

      // 6. 사용되지 않는 이미지 정리
      await _backupService.cleanupUnusedImages();
    } catch (e) {
      throw Exception('파일 복원 실패: $e');
    }
  }

  @override
  Future<BackupInfo> backupToAppInternal() async {
    try {
      // 모든 일기 가져오기
      final diaries = await _diaryRepository.getAllDiaries();

      // 앱 내부에 백업 파일 저장 (이미지 포함)
      final savedFile = await _backupService.saveInternalIsarBackup();
      final stat = await savedFile.stat();

      // 백업 정보 생성
      final backupInfo = BackupInfo(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        type: BackupType.appInternal,
        location: savedFile.path,
        diaryCount: diaries.length,
        fileSize: stat.size,
        status: BackupStatus.completed,
      );

      // 히스토리에 저장
      await _saveBackupHistory(backupInfo);

      return backupInfo;
    } catch (e) {
      throw Exception('앱 내부 백업 실패: $e');
    }
  }

  @override
  Future<void> restoreFromBackup(BackupInfo backupInfo) async {
    try {
      File backupFile;

      switch (backupInfo.type) {
        case BackupType.googleDrive:
          // 구글 드라이브에서 다운로드
          final data = await _driveService.downloadFile(backupInfo.id);
          final tempDir = await Directory.systemTemp.createTemp();
          backupFile = File('${tempDir.path}/restore.zip');
          await backupFile.writeAsBytes(data);
          break;

        case BackupType.localFile:
        case BackupType.appInternal:
          backupFile = File(backupInfo.location);
          if (!await backupFile.exists()) {
            throw Exception('백업 파일을 찾을 수 없습니다');
          }
          break;
      }

      // 백업 파일에서 데이터 추출 (이미지 포함)
      final diaries = await _backupService.extractBackupDataWithImages(
        backupFile,
      );

      // 기존 데이터 모두 삭제
      await _backupService.clearAllData();

      // 복원된 데이터 저장
      for (final diary in diaries) {
        await _diaryRepository.saveDiary(diary);
      }

      // 사용되지 않는 이미지 정리
      await _backupService.cleanupUnusedImages();

      // 임시 파일 삭제 (구글 드라이브 다운로드의 경우)
      if (backupInfo.type == BackupType.googleDrive) {
        await backupFile.delete();
      }
    } catch (e) {
      throw Exception('백업 복원 실패: $e');
    }
  }

  @override
  Future<void> deleteBackup(BackupInfo backup) async {
    try {
      if (backup.type == BackupType.appInternal) {
        final file = File(backup.location);
        if (await file.exists()) {
          await file.delete();
        } else {
          throw Exception('삭제할 백업 파일이 존재하지 않습니다.');
        }
      } else if (backup.type == BackupType.googleDrive) {
        // Google Drive 백업 삭제 (선택 사항)
        await _driveService.deleteFile(backup.id);
      } else {
        throw Exception('이 백업 타입은 삭제를 지원하지 않습니다.');
      }
    } catch (e) {
      throw Exception('백업 삭제 실패: $e');
    }
  }

  @override
  Future<bool> isGoogleDriveConnected() async {
    return await _driveService.isSignedIn();
  }

  @override
  Future<void> signInToGoogleDrive() async {
    await _driveService.signIn();
  }

  @override
  Future<void> signOutFromGoogleDrive() async {
    await _driveService.signOut();
  }

  // Private helper methods
  Future<void> _saveBackupHistory(BackupInfo backupInfo) async {}

  @override
  Future<List<BackupInfo>> getBackupHistory() async {
    try {
      // 앱 내부 백업 폴더 조회
      final backupDir = await _backupService.getInternalBackupDir();
      if (!await backupDir.exists()) return [];

      final files =
          backupDir
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.zip'))
              .toList()
            ..sort(
              (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
            );

      final List<BackupInfo> history = [];

      for (final file in files) {
        final stat = await file.stat();

        history.add(
          BackupInfo(
            id: const Uuid().v4(),
            createdAt: stat.modified,
            type: BackupType.appInternal,
            location: file.path,
            diaryCount: await _backupService.countBackupDiaries(file),
            fileSize: stat.size,
            status: BackupStatus.completed,
          ),
        );
      }

      return history;
    } catch (e) {
      throw Exception('앱 내부 백업 목록 불러오기 실패: $e');
    }
  }
}
