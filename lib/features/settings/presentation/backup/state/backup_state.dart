import 'package:line_a_day/features/settings/domain/model/backup_info.dart';

class BackupState {
  final List<BackupInfo> backupHistory;
  final bool isLoading;
  final bool isGoogleDriveConnected;
  final String? errorMessage;
  final String? successMessage;
  final BackupInfo? lastBackup;

  BackupState({
    this.backupHistory = const [],
    this.isLoading = false,
    this.isGoogleDriveConnected = false,
    this.errorMessage,
    this.successMessage,
    this.lastBackup,
  });

  BackupState copyWith({
    List<BackupInfo>? backupHistory,
    bool? isLoading,
    bool? isGoogleDriveConnected,
    String? errorMessage,
    String? successMessage,
    BackupInfo? lastBackup,
  }) {
    return BackupState(
      backupHistory: backupHistory ?? this.backupHistory,
      isLoading: isLoading ?? this.isLoading,
      isGoogleDriveConnected:
          isGoogleDriveConnected ?? this.isGoogleDriveConnected,
      errorMessage: errorMessage,
      successMessage: successMessage,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }
}
