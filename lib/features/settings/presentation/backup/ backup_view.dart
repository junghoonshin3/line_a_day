// lib/features/settings/presentation/backup/backup_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/settings/domain/model/backup_info.dart';
import 'package:line_a_day/features/settings/presentation/backup/%20backup_view_model.dart';
import 'package:line_a_day/features/settings/presentation/backup/state/backup_state.dart';
import 'package:line_a_day/widgets/common/dialog/dialog_helper.dart';
import 'package:line_a_day/widgets/common/staggered_animation/staggered_animation_mixin.dart';
import 'package:line_a_day/widgets/settings/backup_history_item.dart';
import 'package:line_a_day/widgets/settings/backup_option_card.dart';

class BackupView extends ConsumerStatefulWidget {
  const BackupView({super.key});

  @override
  ConsumerState<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends ConsumerState<BackupView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupViewModelProvider);
    final viewModel = ref.read(backupViewModelProvider.notifier);

    // 상태 변화 감지
    ref.listen<BackupState>(backupViewModelProvider, (previous, next) {
      // 성공 메시지
      if (next.successMessage != null &&
          previous?.successMessage != next.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(next.successMessage!)),
              ],
            ),
            backgroundColor: AppTheme.primaryBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        viewModel.clearMessages();
      }

      // 에러 메시지
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(next.errorMessage!)),
              ],
            ),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        viewModel.clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: const Text('백업 및 복원'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // _buildHeader(),
              buildAnimatedSliverBox(
                index: 3,
                child: _buildBackupOptions(state, viewModel),
              ),
              buildAnimatedSliverBox(
                index: 4,
                child: _buildBackupHistory(state, viewModel),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
          if (state.isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFadeItem(
                index: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      '백업 및 복원',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              buildAnimatedItem(
                index: 1,
                child: const Text(
                  '소중한 일기를 안전하게 보관하세요',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackupOptions(BackupState state, viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('백업 방법 선택', style: AppTheme.headlineMedium),
          const SizedBox(height: 16),
          // BackupOptionCard(
          //   icon: Icons.cloud,
          //   title: '구글 드라이브',
          //   description: '클라우드에 안전하게 저장',
          //   iconColor: const Color(0xFF4285F4),
          //   isConnected: state.isGoogleDriveConnected,
          //   onTap: () => _onGoogleDriveBackup(viewModel),
          // ),
          // const SizedBox(height: 12),
          BackupOptionCard(
            icon: Icons.save_alt,
            title: '파일로 저장',
            description: '원하는 위치에 백업 파일 저장',
            iconColor: const Color(0xFFF59E0B),
            onTap: () => viewModel.saveBackupFile(),
          ),
          const SizedBox(height: 12),
          BackupOptionCard(
            icon: Icons.phone_android,
            title: '앱 내 백업',
            description: '기기 내부에 백업 저장',
            iconColor: const Color(0xFF8B5CF6),
            onTap: () => viewModel.backupToAppInternal(),
          ),
          const SizedBox(height: 24),
          const Text('복원하기', style: AppTheme.headlineMedium),
          const SizedBox(height: 16),
          BackupOptionCard(
            icon: Icons.folder_open,
            title: '파일에서 복원',
            description: '저장된 백업 파일을 선택하여 복원',
            iconColor: const Color(0xFF10B981),
            onTap: () => _onRestoreFromFile(viewModel),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildBackupHistory(BackupState state, BackupViewModel viewModel) {
    final internalBackups = state.backupHistory
        .where((b) => b.type == BackupType.appInternal)
        .toList();

    if (internalBackups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Text(
                '💾',
                style: TextStyle(
                  fontSize: 64,
                  color: AppTheme.gray300.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '앱 내 백업 데이터가 없습니다',
                textAlign: TextAlign.center,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.gray400,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('앱 내 백업 기록', style: AppTheme.headlineMedium),
              TextButton.icon(
                onPressed: () => viewModel.refreshHistory(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('새로고침'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...internalBackups.map((backup) {
            return BackupHistoryItem(
              backupInfo: backup,
              onRestore: () => _onRestoreBackup(context, viewModel, backup),
              onDelete: () => _onDeleteBackup(context, viewModel, backup),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Card(
          margin: EdgeInsets.all(40),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('처리 중...', style: AppTheme.titleMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Actions
  void _onGoogleDriveBackup(viewModel) async {
    if (!ref.read(backupViewModelProvider).isGoogleDriveConnected) {
      await DialogHelper.showConfirm(
        context,
        title: '구글 드라이브 연결',
        message: '구글 드라이브에 백업하려면 로그인이 필요합니다.\n지금 로그인하시겠습니까?',
        icon: Icons.cloud,
        confirmText: '로그인',
        cancelText: '취소',
        onConfirm: () async {
          await viewModel.signInToGoogleDrive();
          if (ref.read(backupViewModelProvider).isGoogleDriveConnected) {
            await viewModel.backupToGoogleDrive();
          }
        },
      );
    } else {
      await viewModel.backupToGoogleDrive();
    }
  }

  void _onRestoreFromFile(BackupViewModel viewModel) async {
    final confirmed = await DialogHelper.showConfirm(
      context,
      title: '파일에서 복원',
      message:
          '저장된 백업 파일을 선택하여 복원합니다.\n현재 저장된 모든 일기가 백업 내용으로 교체됩니다.\n계속하시겠습니까?',
      icon: Icons.folder_open,
      iconColor: const Color(0xFF10B981),
      confirmText: '파일 선택',
      cancelText: '취소',
      onConfirm: () {
        viewModel.restoreFromFile();
      },
      onCancel: () {},
    );

    if (confirmed) {
      await viewModel.restoreFromFile();
    }
  }

  void _onRestoreBackup(BuildContext context, viewModel, backup) async {
    if (!backup.canRestore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('파일로 저장한 백업은 "파일에서 복원" 메뉴를 이용해주세요.')),
            ],
          ),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    await DialogHelper.showConfirm(
      context,
      title: '백업 복원',
      message:
          '이 백업을 복원하시겠습니까?\n\n⚠️ 현재 저장된 모든 일기가 백업 내용으로 교체됩니다.\n\n백업 정보:\n• ${backup.diaryCount}개의 일기\n• ${backup.formattedSize}',
      icon: Icons.warning,
      iconColor: AppTheme.warningYellow,
      confirmText: '복원하기',
      cancelText: '취소',
      onConfirm: () => viewModel.restoreFromBackup(backup),
    );
  }

  void _onDeleteBackup(
    BuildContext context,
    BackupViewModel viewModel,
    BackupInfo backup,
  ) async {
    await DialogHelper.showConfirm(
      context,
      title: '백업 삭제',
      message: '이 백업을 삭제하시겠습니까?\n삭제된 백업은 복구할 수 없습니다.',
      icon: Icons.delete_forever,
      iconColor: AppTheme.errorRed,
      confirmText: '삭제',
      cancelText: '취소',
      onConfirm: () => viewModel.deleteBackup(backup),
    );
  }
}
