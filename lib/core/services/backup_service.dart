// lib/core/services/backup_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:line_a_day/shared/constants/weather_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar_community/isar.dart';
import 'package:line_a_day/core/database/diary_entity.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:path/path.dart' as p;

class BackupService {
  final Isar _isar;

  BackupService(this._isar);

  /// 앱 이미지 디렉토리 가져오기
  Future<Directory> getAppImagesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/diary_images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir;
  }

  /// 백업 파일 생성 (이미지 포함)
  Future<File> createIsarBackupWithImages() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupTempDir = Directory('${tempDir.path}/backup_$timestamp');
    await backupTempDir.create(recursive: true);

    // 1. 일기 개수 가져오기
    final diaryCount = await _isar.diaryEntitys.count();

    // 2. 메타데이터 생성
    final metadata = {
      'version': '1.0.0',
      'appName': 'LineADay',
      'createdAt': DateTime.now().toIso8601String(),
      'diaryCount': diaryCount,
      'backupType': 'isar_with_images',
    };
    final metadataFile = File('${backupTempDir.path}/metadata.json');
    await metadataFile.writeAsString(jsonEncode(metadata));

    // 3. Isar 파일 복사
    final isarPath = _isar.directory!;
    final isarFile = File('$isarPath/line_a_day.isar');

    if (await isarFile.exists()) {
      final isarBackupFile = File('${backupTempDir.path}/line_a_day.isar');
      await isarFile.copy(isarBackupFile.path);
    }

    // 4. 모든 일기의 이미지 경로 수집
    final allDiaries = await _isar.diaryEntitys.where().findAll();
    final Set<String> allImagePaths = {};

    for (final diary in allDiaries) {
      if (diary.photoUrls != null) {
        allImagePaths.addAll(diary.photoUrls!);
      }
    }

    // 5. 이미지 파일들 복사
    if (allImagePaths.isNotEmpty) {
      final imagesBackupDir = Directory('${backupTempDir.path}/images');
      await imagesBackupDir.create(recursive: true);

      int copiedCount = 0;
      for (final imagePath in allImagePaths) {
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          final fileName = p.basename(imagePath);
          final destFile = File('${imagesBackupDir.path}/$fileName');
          await imageFile.copy(destFile.path);
          copiedCount++;
        }
      }

      print('✅ 이미지 백업 완료: $copiedCount/${allImagePaths.length}개');
    }

    // 6. ZIP으로 압축
    final zipFile = File('${tempDir.path}/LineADay_Backup_$timestamp.zip');

    // 전체 디렉토리를 ZIP으로 압축
    final encoder = ZipFileEncoder();
    encoder.create(zipFile.path);
    encoder.addDirectory(backupTempDir);
    encoder.close();

    // 7. 임시 디렉토리 삭제
    await backupTempDir.delete(recursive: true);

    return zipFile;
  }

  /// 백업 파일 검증
  Future<bool> validateBackupFile(File zipFile) async {
    try {
      if (!await zipFile.exists()) {
        return false;
      }

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 메타데이터 파일 확인
      final hasMetadata = archive.files.any(
        (file) => file.name.endsWith('metadata.json'),
      );

      if (!hasMetadata) {
        return false;
      }

      // 메타데이터 파싱
      final metadataFile = archive.files.firstWhere(
        (file) => file.name.endsWith('metadata.json'),
      );
      final metadataString = utf8.decode(metadataFile.content as List<int>);
      final metadata = jsonDecode(metadataString) as Map<String, dynamic>;

      // 필수 필드 확인
      if (!metadata.containsKey('version') ||
          !metadata.containsKey('appName') ||
          !metadata.containsKey('backupType')) {
        return false;
      }

      // 앱 이름 확인
      if (metadata['appName'] != 'LineADay') {
        return false;
      }

      return true;
    } catch (e) {
      print('❌ 백업 파일 검증 실패: $e');
      return false;
    }
  }

  /// 백업 파일에서 데이터 추출 및 복원 (이미지 포함)
  Future<List<DiaryModel>> extractBackupDataWithImages(File zipFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final extractDir = Directory(
        '${tempDir.path}/extract_${DateTime.now().millisecondsSinceEpoch}',
      );
      await extractDir.create(recursive: true);

      print('📂 압축 해제 시작: ${zipFile.path}');

      // 1. ZIP 압축 해제
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      print('📦 ZIP 파일 내용: ${archive.files.length}개 파일');

      // 모든 파일 추출
      for (final file in archive.files) {
        if (file.isFile) {
          final filePath = '${extractDir.path}/${file.name}';
          final outputFile = File(filePath);
          await outputFile.create(recursive: true);
          await outputFile.writeAsBytes(file.content as List<int>);
          print('  ✓ ${file.name}');
        }
      }

      // 2. 메타데이터 읽기
      final metadataFiles = extractDir
          .listSync(recursive: true)
          .where((f) => f.path.endsWith('metadata.json'))
          .toList();

      if (metadataFiles.isEmpty) {
        throw Exception('메타데이터 파일을 찾을 수 없습니다');
      }

      final metadataFile = File(metadataFiles.first.path);
      final metadataString = await metadataFile.readAsString();
      final metadata = jsonDecode(metadataString) as Map<String, dynamic>;
      final backupType = metadata['backupType'] as String;

      print('📋 백업 타입: $backupType');

      // 3. Isar 파일 찾기
      final isarFiles = extractDir
          .listSync(recursive: true)
          .where((f) => f.path.endsWith('.isar'))
          .toList();

      if (isarFiles.isEmpty) {
        throw Exception('Isar 데이터베이스 파일을 찾을 수 없습니다');
      }

      final isarFile = File(isarFiles.first.path);
      print('💾 Isar 파일 발견: ${p.basename(isarFile.path)}');

      // 4. Isar 파일을 적절한 위치로 복사
      final tempIsarFile = File('${extractDir.path}/restore_temp.isar');
      await isarFile.copy(tempIsarFile.path);

      // 5. 임시 Isar 인스턴스로 데이터 읽기
      print('📖 Isar 데이터 읽기 시작...');
      final tempIsar = await Isar.open(
        [DiaryEntitySchema],
        directory: extractDir.path,
        name: 'restore_temp',
      );

      final entities = await tempIsar.diaryEntitys.where().findAll();
      print('📝 일기 데이터: ${entities.length}개');

      // 6. 이미지 복원
      final imagesBackupDirs = extractDir
          .listSync(recursive: true)
          .where((f) => f is Directory && p.basename(f.path) == 'images')
          .toList();

      final appImagesDir = await getAppImagesDirectory();

      // 새로운 경로 매핑 (백업 경로 → 앱 경로)
      final Map<String, String> pathMapping = {};

      if (imagesBackupDirs.isNotEmpty) {
        final imagesBackupDir = Directory(imagesBackupDirs.first.path);
        final imageFiles = imagesBackupDir.listSync();
        print('📸 복원할 이미지: ${imageFiles.length}개');

        for (final imageFile in imageFiles) {
          if (imageFile is File) {
            final fileName = p.basename(imageFile.path);
            final newPath = '${appImagesDir.path}/$fileName';

            try {
              // 이미지 파일 복사
              await imageFile.copy(newPath);

              // 경로 매핑 저장 (파일명으로 매칭)
              pathMapping[fileName] = newPath;
              print('  ✓ $fileName → ${p.basename(newPath)}');
            } catch (e) {
              print('  ⚠️ 이미지 복사 실패: $fileName - $e');
            }
          }
        }

        print('✅ 이미지 복원 완료: ${pathMapping.length}개');
      } else {
        print('ℹ️ 백업에 이미지가 없습니다');
      }

      // 7. DiaryModel로 변환 (이미지 경로 업데이트)
      final diaries = entities.map((e) {
        List<String> updatedPhotoUrls = [];

        if (e.photoUrls != null) {
          for (final oldPath in e.photoUrls!) {
            final fileName = p.basename(oldPath);
            final newPath = pathMapping[fileName];

            if (newPath != null) {
              updatedPhotoUrls.add(newPath);
            } else {
              print('  ⚠️ 경로 매핑 실패: $fileName');
              // 매핑을 찾지 못한 경우 새 경로 생성 시도
              final possibleNewPath = '${appImagesDir.path}/$fileName';
              final possibleFile = File(possibleNewPath);
              if (possibleFile.existsSync()) {
                updatedPhotoUrls.add(possibleNewPath);
              }
            }
          }
        }

        return DiaryModel(
          id: e.id,
          createdAt: e.createdAt,
          title: e.title,
          content: e.content,
          emotion: e.emotionType,
          tags: e.tags ?? [],
          photoUrls: updatedPhotoUrls,
          weather: WeatherData.getWeatherByValue(e.weather),
          location: e.location,
          isFavorite: e.isFavorite,
          lastModified: e.lastModified,
        );
      }).toList();

      print('✅ 일기 변환 완료: ${diaries.length}개');

      // 8. 임시 Isar 닫기 및 정리
      await tempIsar.close(deleteFromDisk: true);

      // 정리 시도 (실패해도 계속 진행)
      try {
        await extractDir.delete(recursive: true);
      } catch (e) {
        print('⚠️ 임시 디렉토리 삭제 실패: $e');
      }

      return diaries;
    } catch (e, stackTrace) {
      print('❌ 백업 데이터 추출 실패: $e');
      print('Stack trace: $stackTrace');
      throw Exception('백업 데이터 추출 실패: $e');
    }
  }

  /// 앱 내부 백업 디렉토리 가져오기
  Future<Directory> getInternalBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    return backupDir;
  }

  /// 앱 내부 백업 파일 저장 (이미지 포함)
  Future<File> saveInternalIsarBackup() async {
    final backupFile = await createIsarBackupWithImages();
    final backupDir = await getInternalBackupDirectory();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final savedFile = File('${backupDir.path}/backup_$timestamp.zip');

    await backupFile.copy(savedFile.path);
    await backupFile.delete();

    return savedFile;
  }

  /// 앱 내부 백업 파일 목록
  Future<List<FileSystemEntity>> listInternalBackups() async {
    final backupDir = await getInternalBackupDirectory();
    final files = backupDir
        .listSync()
        .where((file) => file.path.endsWith('.zip'))
        .toList();

    // 최신순 정렬
    files.sort(
      (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
    );

    return files;
  }

  /// 백업 파일 삭제
  Future<void> deleteBackupFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 전체 데이터 삭제 (복원 전 기존 데이터 제거)
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.diaryEntitys.clear();
    });
  }

  /// 사용되지 않는 이미지 정리
  Future<void> cleanupUnusedImages() async {
    try {
      final imagesDir = await getAppImagesDirectory();
      final imageFiles = imagesDir.listSync();

      // 모든 일기의 이미지 경로 수집
      final allDiaries = await _isar.diaryEntitys.where().findAll();
      final Set<String> usedImagePaths = {};

      for (final diary in allDiaries) {
        if (diary.photoUrls != null) {
          usedImagePaths.addAll(diary.photoUrls!);
        }
      }

      // 사용되지 않는 이미지 삭제
      int deletedCount = 0;
      for (final imageFile in imageFiles) {
        if (imageFile is File) {
          if (!usedImagePaths.contains(imageFile.path)) {
            await imageFile.delete();
            deletedCount++;
          }
        }
      }

      print('🧹 정리된 이미지: $deletedCount개');
    } catch (e) {
      print('⚠️ 이미지 정리 실패: $e');
    }
  }

  Future<Directory> getInternalBackupDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// zip 내부에 일기 데이터가 몇 개 포함되어 있는지 계산 (옵션)
  Future<int> countBackupDiaries(File zipFile) async {
    try {
      // 압축 해제 없이 파일 이름만 추출 가능 (archive 패키지 이용)
      final inputStream = InputFileStream(zipFile.path);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      final diaryEntries = archive.files
          .where((f) => f.name.endsWith('.json'))
          .toList();
      inputStream.close();
      return diaryEntries.length;
    } catch (_) {
      return 0;
    }
  }
}
