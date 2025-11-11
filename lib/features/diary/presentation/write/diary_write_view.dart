import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/diary/domain/model/diary_model.dart';
import 'package:line_a_day/features/diary/presentation/state/diary_write_state.dart';
import 'package:line_a_day/features/diary/presentation/write/diary_write_view_model.dart';
import 'package:line_a_day/widgets/common/custom_snackbar.dart';
import 'package:line_a_day/widgets/common/dialog/dialog_helper.dart';
import 'package:line_a_day/widgets/common/staggered_animation/staggered_animation_mixin.dart';
import 'package:line_a_day/widgets/diary/dialog/diary_dialogs.dart';

class DiaryWriteView extends ConsumerStatefulWidget {
  const DiaryWriteView({super.key});

  @override
  ConsumerState<DiaryWriteView> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends ConsumerState<DiaryWriteView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;
      final viewModel = ref.read(diaryWriteViewModelProvider.notifier);
      if (args is DiaryModel) {
        viewModel.loadForEdit(args, true);
      } else {
        viewModel.checkDraft();
      }
    });
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _draftPopUp(DiaryWriteState state, DiaryWriteViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DialogHelper.showConfirm(
        context,
        title: '임시 저장된 일기',
        message: '작성 중이던 일기가 있습니다.\n이어서 작성하시겠습니까?',
        icon: Icons.edit_note,
        confirmText: '이어쓰기',
        cancelText: '새로 작성',
        onCancel: () {
          viewModel.clearDraft();
        },
        onConfirm: () {
          viewModel.loadDraft();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryWriteViewModelProvider);
    final viewModel = ref.read(diaryWriteViewModelProvider.notifier);
    final saveButtonText = state.isEditMode ? "수정" : "저장";
    // 상태 변화 감지
    ref.listen<DiaryWriteState>(diaryWriteViewModelProvider, (previous, next) {
      if (previous?.diary.title != next.diary.title &&
          _titleController.text != next.diary.title) {
        _titleController.text = next.diary.title;
      }

      if (next.isDraftPopUpShow && !next.isEditMode) {
        _draftPopUp(state, viewModel);
      }

      if (previous?.diary.content != next.diary.content &&
          _contentController.text != next.diary.content) {
        _contentController.text = next.diary.content;
      }
      // 저장 완료 감지
      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        CustomSnackBar.showSuccess(context, '일기가 저장되었습니다');
      }

      // 임시 저장 완료
      if (next.isDraftSavedCompleted &&
          !(previous?.isDraftSavedCompleted ?? false)) {
        CustomSnackBar.showSuccess(context, '임시 저장되었습니다');
      }

      // 에러 발생
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        CustomSnackBar.showError(context, next.errorMessage!);
      }
    });

    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _contentFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B7280)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          title: const Text(
            '오늘의 일기',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                DiaryDialogs.showDateTimePickerDialog(
                  context: context,
                  focusedDate: state.focusedDate,
                  currentDateTime: state.selectedDate,
                  onDateTimeSelected: (datetime) {
                    viewModel.setFocusedDate(datetime);
                    viewModel.setSelectedDate(datetime);
                  },
                  onPageChanged: (focusedDay) {
                    viewModel.setFocusedDate(focusedDay);
                  },
                  hasEntryOnDate: (date) {
                    return false;
                  },
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            // 스크롤 가능한 내용 부분
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 헤더 섹션
                    buildAnimatedItem(index: 0, child: _buildHeader(state)),
                    const SizedBox(height: 32),

                    // 제목 입력
                    buildAnimatedItem(
                      index: 1,
                      child: _buildTitleInput(state, viewModel),
                    ),
                    const SizedBox(height: 24),

                    // 내용 입력
                    buildAnimatedItem(
                      index: 2,
                      child: _buildContentInput(state, viewModel),
                    ),
                    const SizedBox(height: 32),

                    // 추가 기능들
                    buildAnimatedItem(
                      index: 3,
                      child: _buildAdditionalFeatures(state, viewModel),
                    ),
                    const SizedBox(height: 24), // 하단 버튼 공간
                  ],
                ),
              ),
            ),

            // 고정 하단 버튼
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 임시 저장 버튼
                  if (!state.isEditMode)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          viewModel.saveDraft();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '임시저장',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),

                  // 완료 버튼
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.saveDiary();
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        saveButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DiaryWriteState state) {
    final now = state.diary.createdAt;
    final dateString =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final dayString = '${dayNames[now.weekday - 1]}요일';
    final weather = state.diary.weather;
    final location = state.diary.location;
    final tags = state.diary.tags;
    final emotion = state.diary.emotion;

    // 감정 텍스트 매핑
    final emotionTexts = {
      'happy': '기분 좋은',
      'excited': '신나는',
      'calm': '평온한',
      'tired': '피곤한',
      'sad': '슬픈',
      'angry': '화난',
      'grateful': '감사한',
      'anxious': '불안한',
      'lonely': '외로운',
      'proud': '뿌듯한',
      'bored': '지루한',
      'hopeful': '희망찬',
    };

    const weatherColor = Color(0xFF93C5FD);
    const locationColor = Color(0xFFFCD34D);
    const tagColor = Color(0xFFC4B5FD);
    const emotionColor = Color(0xFFFDA4AF); // 감정 색상

    List<InlineSpan> sentenceParts = [];

    sentenceParts.add(
      const TextSpan(
        text: '오늘은 ',
        style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
      ),
    );

    // 감정 추가
    final emoji = "${Emotion.getMoodByType(emotion)?.emoji}";
    final text = emotionTexts[emotion.name] ?? '특별한';
    sentenceParts.add(
      TextSpan(
        text: '$emoji $text ',
        style: const TextStyle(
          color: emotionColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
    sentenceParts.add(
      const TextSpan(
        text: '기분으로 ',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );

    if (weather != null) {
      sentenceParts.add(
        TextSpan(
          text: '${weather.name} ',
          style: const TextStyle(
            color: weatherColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );
      sentenceParts.add(
        const TextSpan(
          text: '날씨에 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }

    if (location != null) {
      sentenceParts.add(
        TextSpan(
          text: '$location ',
          style: const TextStyle(
            color: locationColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );
      sentenceParts.add(
        const TextSpan(
          text: '에서 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }

    if (tags.isNotEmpty) {
      final tagText = tags.take(3).map((t) => '#$t').join(' ');
      sentenceParts.add(
        TextSpan(
          text: '$tagText ',
          style: const TextStyle(
            color: tagColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );
      sentenceParts.add(
        const TextSpan(
          text: '키워드로 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }

    sentenceParts.add(
      const TextSpan(
        text: '하루를 기록했어요 ✨',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.today, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                dateString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dayString,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (sentenceParts.isNotEmpty)
            RichText(text: TextSpan(children: sentenceParts))
          else
            const Text(
              '오늘 하루는 어떠셨나요?\n소중한 순간들을 기록해보세요 ✨',
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleInput(
    DiaryWriteState state,
    DiaryWriteViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '제목',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            autocorrect: false,
            controller: _titleController,
            focusNode: _titleFocusNode,
            onChanged: viewModel.updateTitle,
            decoration: const InputDecoration(
              hintText: '오늘의 제목을 입력해주세요',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 16),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildContentInput(
    DiaryWriteState state,
    DiaryWriteViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '오늘의 이야기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        if (state.diary.photoUrls.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: state.diary.photoUrls.length,
            itemBuilder: (context, index) {
              final url = state.diary.photoUrls[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.removeImage(index);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            autocorrect: false,
            controller: _contentController,
            focusNode: _contentFocusNode,
            onChanged: viewModel.updateContent,
            decoration: const InputDecoration(
              hintText: '오늘 있었던 일, 느낀 점, 감사한 일 등을 자유롭게 작성해보세요...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 16, height: 1.5),
            maxLines: 12,
            minLines: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFeatures(
    DiaryWriteState state,
    DiaryWriteViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추가 기능',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 감정 선택 (새로 추가)
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.sentiment_satisfied_alt,
                title: '감정 기록',
                subtitle: '지금 기분은?',
                onTap: () {
                  DiaryDialogs.showEmotionDialog(
                    context,
                    onEmotionSelected: (emotion) {
                      viewModel.setEmotion(emotion);
                    },
                    currentEmotion: state.diary.emotion,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // 사진 추가
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.photo_camera,
                title: '사진 추가',
                subtitle: '추억을 남겨보세요',
                onTap: () {
                  DiaryDialogs.showImagePickerBottomSheet(
                    context,
                    onCamera: () async {
                      await viewModel.takePhoto();
                    },
                    onGallery: () async {
                      await viewModel.pickFromGallery();
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // 날씨 기록
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.wb_sunny,
                title: '날씨 기록',
                subtitle: '오늘의 날씨',
                onTap: () {
                  DiaryDialogs.showWeatherDialog(
                    context,
                    onWeatherSelected: (weather) {
                      viewModel.setWeather(weather);
                    },
                    currentWeather: state.diary.weather,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 위치 추가
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.location_on,
                title: '위치 추가',
                subtitle: '특별한 장소',
                onTap: () {
                  DiaryDialogs.showLocationBottomSheet(
                    context,
                    onLocationAdded: (location) {
                      viewModel.setLocation(location);
                    },
                    currentLocation: state.diary.location,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // 태그 추가
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.tag,
                title: '태그 추가',
                subtitle: '키워드로 분류',
                onTap: () {
                  DiaryDialogs.showTagDialog(
                    context,
                    onTagsUpdated: (tags) {
                      viewModel.updateTags(tags);
                    },
                    currentTags: state.diary.tags,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    LinearGradient? gradient, // 추가
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gradient == null
                ? const Color(0xFFE5E7EB)
                : Colors.transparent,
          ),
          boxShadow: gradient != null
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: gradient != null ? Colors.white : const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: gradient != null
                    ? Colors.white
                    : const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: gradient != null
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
