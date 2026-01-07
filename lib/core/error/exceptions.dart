class AppException implements Exception {
  final String message;
  final dynamic originalException;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// 서버 예외
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 캐시 예외
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 저장소 예외
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 인증 예외
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 유효성 검증 예외
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 권한 예외
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 파일 시스템 예외
class FileSystemException extends AppException {
  const FileSystemException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 네트워크 예외
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}