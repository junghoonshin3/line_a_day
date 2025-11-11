import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/routes.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/detail/diary_detail_view_model.dart';
import 'package:line_a_day/widgets/common/custom_snackbar.dart';
import 'package:line_a_day/widgets/common/dialog/dialog_helper.dart';
import 'package:line_a_day/widgets/common/loading_indicator.dart';
import 'package:line_a_day/widgets/common/staggered_animation/staggered_animation_mixin.dart';

class DiaryDetailView extends ConsumerStatefulWidget {
  final int diaryId;

  const DiaryDetailView({super.key, required this.diaryId});

  @override
  ConsumerState<DiaryDetailView> createState() => _DiaryDetailViewState();
}

class _DiaryDetailViewState extends ConsumerState<DiaryDetailView>
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
    final state = ref.watch(diaryDetailViewModelProvider(widget.diaryId));
    final viewModel = ref.read(
      diaryDetailViewModelProvider(widget.diaryId).notifier,
    );

    // 삭제 완료 시 화면 닫기
    ref.listen(diaryDetailViewModelProvider(widget.diaryId), (previous, next) {
      if (next.isDeleted && !(previous?.isDeleted ?? false)) {
        Navigator.of(context).pop(); // 삭제 성공 신호 전달
        CustomSnackBar.showSuccess(context, "일기가 삭제되었습니다");
      }

      // 에러 발생
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        CustomSnackBar.showError(context, next.errorMessage!);
      }
    });

    if (state.isLoading) {
      return const LoadingIndicator();
    }

    if (state.diary == null) {
      return Scaffold(
        backgroundColor: AppTheme.gray50,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.gray300,
              ),
              const SizedBox(height: 16),
              Text(
                '일기를 불러올 수 없습니다',
                style: AppTheme.bodyLarge.copyWith(color: AppTheme.gray400),
              ),
            ],
          ),
        ),
      );
    }

    final diary = state.diary!;

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: CustomScrollView(
        slivers: [
          // 헤더 - 날짜와 액션 버튼
          _buildHeader(context, diary, viewModel),

          // 내용
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  if (diary.title.isNotEmpty)
                    buildAnimatedItem(
                      index: 0,
                      child: _buildTitle(diary.title),
                    ),
                  if (diary.title.isNotEmpty) const SizedBox(height: 24),

                  // 메타 정보 (감정, 날씨, 위치, 태그)
                  buildAnimatedItem(index: 1, child: _buildMetaInfo(diary)),
                  const SizedBox(height: 24),

                  // 사진
                  if (diary.photoUrls.isNotEmpty)
                    buildAnimatedItem(
                      index: 2,
                      child: _buildPhotos(diary.photoUrls),
                    ),
                  if (diary.photoUrls.isNotEmpty) const SizedBox(height: 24),

                  // 본문
                  buildAnimatedItem(
                    index: 3,
                    child: _buildContent(diary.content),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, diary, viewModel) {
    final dateString = DateFormat(
      'yyyy년 MM월 dd일 E',
      'ko',
    ).format(diary.createdAt);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 80,
      elevation: 0,
      leading: buildFadeItem(
        index: 0,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        buildFadeItem(
          index: 1,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _onEdit(context, diary, viewModel),
          ),
        ),
        buildFadeItem(
          index: 2,
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
            onPressed: () => _onDelete(context, viewModel),
          ),
        ),
        const SizedBox(width: 8),
      ],
      title: Text(
        dateString,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMetaInfo(DiaryModel diary) {
    final items = <Widget>[];

    // 감정
    final emotion = Emotion.getMoodByType(diary.emotion);
    if (emotion != null) {
      items.add(
        _buildMetaChip(
          icon: emotion.emoji,
          label: emotion.label,
          color: const Color(0xFFFDA4AF),
        ),
      );
    }

    // 날씨
    if (diary.weather != null) {
      items.add(
        _buildMetaChip(
          icon: diary.weather!.icon,
          label: diary.weather!.name,
          color: const Color(0xFF93C5FD),
        ),
      );
    }

    // 위치
    if (diary.location != null) {
      items.add(
        _buildMetaChip(
          icon: '📍',
          label: diary.location!,
          color: const Color(0xFFFCD34D),
        ),
      );
    }

    // 태그
    for (final tag in diary.tags) {
      items.add(
        _buildMetaChip(icon: '#', label: tag, color: const Color(0xFFC4B5FD)),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }

  Widget _buildMetaChip({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotos(List<String> photoUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '사진',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: photoUrls.length == 1 ? 1 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: photoUrls.length == 1 ? 16 / 9 : 1,
          ),
          itemCount: photoUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageDialog(context, photoUrls, index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(photoUrls[index]),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text("에러..");
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent(String content) {
    if (content.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            '작성된 내용이 없습니다',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.gray400),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          height: 1.8,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, List<String> urls, int index) {
    showDialog(
      fullscreenDialog: true,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [InteractiveViewer(child: Image.file(File(urls[index])))],
        ),
      ),
    );
  }

  void _onEdit(
    BuildContext context,
    DiaryModel diary,
    DiaryDetailViewModel viewModel,
  ) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.diaryWrite, arguments: diary);
  }

  void _onDelete(BuildContext context, viewModel) async {
    await DialogHelper.showConfirm(
      context,
      title: '일기 삭제',
      message: '정말로 이 일기를 삭제하시겠습니까?\n삭제된 일기는 복구할 수 없습니다.',
      icon: Icons.delete_forever,
      confirmText: '삭제',
      cancelText: '취소',
      onConfirm: viewModel.deleteDiary,
      onCancel: () {},
    );
  }
}
