// lib/widgets/settings/backup_history_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/features/settings/domain/model/backup_info.dart';

class BackupHistoryItem extends StatelessWidget {
  final BackupInfo backupInfo;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const BackupHistoryItem({
    super.key,
    required this.backupInfo,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTypeIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(backupInfo.type.label, style: AppTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'yyyy.MM.dd HH:mm',
                      ).format(backupInfo.createdAt),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.gray600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  if (backupInfo.canRestore)
                    const PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(
                            Icons.restore,
                            size: 20,
                            color: AppTheme.gray700,
                          ),
                          SizedBox(width: 12),
                          Text('복원하기'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: AppTheme.errorRed),
                        SizedBox(width: 12),
                        Text(
                          '삭제하기',
                          style: TextStyle(color: AppTheme.errorRed),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'restore') {
                    onRestore();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.description,
                label: '${backupInfo.diaryCount}개',
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                icon: Icons.storage,
                label: backupInfo.formattedSize,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (backupInfo.type) {
      case BackupType.googleDrive:
        icon = Icons.cloud;
        color = const Color(0xFF4285F4);
        break;
      case BackupType.localFile:
        icon = Icons.save_alt;
        color = const Color(0xFFF59E0B);
        break;
      case BackupType.appInternal:
        icon = Icons.phone_android;
        color = const Color(0xFF8B5CF6);
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.gray600),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.labelMedium.copyWith(color: AppTheme.gray700),
          ),
        ],
      ),
    );
  }
}
