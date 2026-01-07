import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/services/image_picker_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';
import 'package:line_a_day/features/diary/domain/repository/diary_repository.dart';
import 'package:line_a_day/features/diary/domain/repository/draft_repository.dart';
import 'package:line_a_day/features/diary/presentation/diary_write/state/diary_write_state.dart';
import 'package:line_a_day/shared/constants/emotion_constants.dart';
import 'package:line_a_day/shared/constants/weather_constants.dart';

class DiaryWriteViewModel extends StateNotifier<DiaryWriteState> {
  DiaryWriteViewModel({
    required this.draftRepository,
    required this.diaryRepository,
  }) : super(
         DiaryWriteState(
           diary: DiaryModel(
             createdAt: DateTime.now(),
             title: "",
             content: "",
             emotion: EmotionType.calm,
           ),
         ),
       );
  final DraftRepository draftRepository;
  final DiaryRepository diaryRepository;
  final ImagePickerService _imagePickerService = ImagePickerService();

  void checkDraft() {
    final hasDraft = draftRepository.hasDraft();
    state = state.copyWith(isDraftSaved: hasDraft, isDraftPopUpShow: hasDraft);
  }

  void loadDraft() {
    final draft = draftRepository.loadDraft();
    state = state.copyWith(diary: draft, isDraftPopUpShow: false);
  }

  void clearDraft() async {
    try {
      await draftRepository.clearDraft();
      state = state.copyWith(isDraftSaved: false, isDraftPopUpShow: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void saveDraft() async {
    state = state.copyWith(isLoading: true);
    try {
      await draftRepository.saveDraft(state.diary);
      state = state.copyWith(
        isDraftSavedCompleted: true,
        diary: state.diary,
        successMessage: "임시저장 성공",
      );
    } catch (e) {
      state = state.copyWith(
        isDraftSavedCompleted: false,
        errorMessage: e.toString(),
      );
    } finally {
      state = state.copyWith(isLoading: false, isDraftPopUpShow: false);
    }
  }

  void saveDiary() async {
    state = state.copyWith(isLoading: true);
    try {
      await diaryRepository.saveDiary(state.diary);
      await draftRepository.clearDraft();
      state = state.copyWith(diary: state.diary, isCompleted: true);
    } catch (e) {
      if (mounted) {
        state = state.copyWith(errorMessage: e.toString(), isCompleted: false);
      }
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> pickFromGallery() async {
    final photoUrl = await _imagePickerService.pickMultipleImages();
    if (photoUrl.isNotEmpty) {
      state = state.copyWith(
        diary: state.diary.copyWith(
          photoUrls: [...state.diary.photoUrls, ...photoUrl],
        ),
      );
    }
  }

  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      diary: state.diary.copyWith(createdAt: date),
    );
  }

  // 카메라로 사진 촬영
  Future<void> takePhoto() async {
    final photoUrl = await _imagePickerService.pickImageFromCamera();
    if (photoUrl != null) {
      state = state.copyWith(
        diary: state.diary.copyWith(
          photoUrls: [...state.diary.photoUrls, photoUrl],
        ),
      );
    }
  }

  // 이미지 삭제
  void removeImage(int index) {
    final updatedImages = List<String>.from(state.diary.photoUrls);
    updatedImages.removeAt(index);
    state = state.copyWith(
      diary: state.diary.copyWith(photoUrls: updatedImages),
    );
  }

  void setWeather(WeatherData weather) {
    state = state.copyWith(diary: state.diary.copyWith(weather: weather));
  }

  void setLocation(String location) {
    state = state.copyWith(
      diary: state.diary.copyWith(location: location.isEmpty ? null : location),
    );
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(diary: state.diary.copyWith(tags: tags));
  }

  void setEmotion(Emotion emotion) {
    state = state.copyWith(diary: state.diary.copyWith(emotion: emotion.type));
  }

  // 제목 업데이트
  void updateTitle(String title) {
    state = state.copyWith(diary: state.diary.copyWith(title: title));
  }

  // 본문 업데이트
  void updateContent(String content) {
    state = state.copyWith(diary: state.diary.copyWith(content: content));
  }

  void loadForEdit(DiaryModel diary, bool isEditMode) {
    state = state.copyWith(
      diary: diary,
      isDraftPopUpShow: false,
      isEditMode: isEditMode,
    );
  }
}

final diaryWriteViewModelProvider =
    StateNotifierProvider.autoDispose<DiaryWriteViewModel, DiaryWriteState>((
      ref,
    ) {
      final viewModel = DiaryWriteViewModel(
        draftRepository: ref.watch(draftRepositoryProvider),
        diaryRepository: ref.watch(diaryRepositoryProvider),
      );

      return viewModel;
    });
