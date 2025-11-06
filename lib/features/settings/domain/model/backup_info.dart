// lib/features/settings/domain/model/backup_info.dart

class BackupInfo {
  final String id;
  final DateTime createdAt;
  final BackupType type;
  final String location;
  final int diaryCount;
  final int fileSize; // bytes
  final BackupStatus status;
  final bool canRestore; // 복원 가능 여부

  BackupInfo({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.location,
    required this.diaryCount,
    required this.fileSize,
    this.status = BackupStatus.completed,
    this.canRestore = true,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  BackupInfo copyWith({
    String? id,
    DateTime? createdAt,
    BackupType? type,
    String? location,
    int? diaryCount,
    int? fileSize,
    BackupStatus? status,
    bool? canRestore,
  }) {
    return BackupInfo(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      location: location ?? this.location,
      diaryCount: diaryCount ?? this.diaryCount,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
      canRestore: canRestore ?? this.canRestore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
      'location': location,
      'diaryCount': diaryCount,
      'fileSize': fileSize,
      'status': status.name,
      'canRestore': canRestore,
    };
  }

  factory BackupInfo.fromJson(Map<String, dynamic> json) {
    return BackupInfo(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      type: BackupType.values.firstWhere((e) => e.name == json['type']),
      location: json['location'],
      diaryCount: json['diaryCount'],
      fileSize: json['fileSize'],
      status: BackupStatus.values.firstWhere((e) => e.name == json['status']),
      canRestore: json['canRestore'] ?? true,
    );
  }
}

enum BackupType {
  googleDrive('구글 드라이브'),
  localFile('파일로 저장'),
  appInternal('앱 내 백업');

  final String label;
  const BackupType(this.label);
}

enum BackupStatus { pending, inProgress, completed, failed }
