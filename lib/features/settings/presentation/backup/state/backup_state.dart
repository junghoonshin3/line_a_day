import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/features/settings/domain/model/backup_info.dart';

class BackupState extends BaseState {
  final List<BackupInfo> backupHistory;
  final bool isGoogleDriveConnected;
  final String? successMessage;
  final BackupInfo? lastBackup;

  BackupState({
    this.backupHistory = const [],
    super.isLoading = false,
    this.isGoogleDriveConnected = false,
    super.errorMessage,
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
