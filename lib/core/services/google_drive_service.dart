import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveFileScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;

  /// 로그인 상태 확인
  Future<bool> isSignedIn() async {
    _currentUser = await _googleSignIn.signInSilently();
    return _currentUser != null;
  }

  /// 구글 로그인
  Future<void> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) {
        throw Exception('구글 로그인이 취소되었습니다');
      }
      await _initializeDriveApi();
    } catch (e) {
      throw Exception('구글 로그인 실패: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _driveApi = null;
  }

  /// Drive API 초기화
  Future<void> _initializeDriveApi() async {
    if (_currentUser == null) return;

    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(authenticateClient);
  }

  /// 파일 업로드
  Future<String> uploadFile({
    required File file,
    required String fileName,
    String? folderId,
  }) async {
    if (_driveApi == null) {
      await _initializeDriveApi();
    }

    if (_driveApi == null) {
      throw Exception('Drive API가 초기화되지 않았습니다');
    }

    try {
      final driveFile = drive.File();
      driveFile.name = fileName;

      if (folderId != null) {
        driveFile.parents = [folderId];
      }

      final media = drive.Media(file.openRead(), file.lengthSync());

      final response = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      return response.id ?? '';
    } catch (e) {
      throw Exception('파일 업로드 실패: $e');
    }
  }

  /// 파일 다운로드
  Future<List<int>> downloadFile(String fileId) async {
    if (_driveApi == null) {
      await _initializeDriveApi();
    }

    if (_driveApi == null) {
      throw Exception('Drive API가 초기화되지 않았습니다');
    }

    try {
      final media =
          await _driveApi!.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final List<int> dataStore = [];
      await for (var data in media.stream) {
        dataStore.addAll(data);
      }

      return dataStore;
    } catch (e) {
      throw Exception('파일 다운로드 실패: $e');
    }
  }

  /// Line A Day 폴더 찾기 또는 생성
  Future<String> getOrCreateAppFolder() async {
    if (_driveApi == null) {
      await _initializeDriveApi();
    }

    if (_driveApi == null) {
      throw Exception('Drive API가 초기화되지 않았습니다');
    }

    try {
      // 기존 폴더 검색
      final fileList = await _driveApi!.files.list(
        q: "name='LineADay_Backups' and mimeType='application/vnd.google-apps.folder' and trashed=false",
        spaces: 'drive',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.id!;
      }

      // 폴더 생성
      final folder = drive.File();
      folder.name = 'LineADay_Backups';
      folder.mimeType = 'application/vnd.google-apps.folder';

      final createdFolder = await _driveApi!.files.create(folder);
      return createdFolder.id!;
    } catch (e) {
      throw Exception('폴더 생성 실패: $e');
    }
  }

  /// 앱 폴더의 백업 파일 목록 조회
  Future<List<drive.File>> listBackupFiles() async {
    if (_driveApi == null) {
      await _initializeDriveApi();
    }

    if (_driveApi == null) {
      throw Exception('Drive API가 초기화되지 않았습니다');
    }

    try {
      final folderId = await getOrCreateAppFolder();

      final fileList = await _driveApi!.files.list(
        q: "'$folderId' in parents and trashed=false",
        orderBy: 'createdTime desc',
        spaces: 'drive',
      );

      return fileList.files ?? [];
    } catch (e) {
      throw Exception('백업 목록 조회 실패: $e');
    }
  }

  /// 파일 삭제
  Future<void> deleteFile(String fileId) async {
    if (_driveApi == null) {
      await _initializeDriveApi();
    }

    if (_driveApi == null) {
      throw Exception('Drive API가 초기화되지 않았습니다');
    }

    try {
      await _driveApi!.files.delete(fileId);
    } catch (e) {
      throw Exception('파일 삭제 실패: $e');
    }
  }
}

/// 인증된 HTTP 클라이언트
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
