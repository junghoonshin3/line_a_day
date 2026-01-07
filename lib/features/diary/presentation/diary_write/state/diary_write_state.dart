import 'package:line_a_day/core/base/base_state.dart';
import 'package:line_a_day/features/diary/data/model/diary_model.dart';

class DiaryWriteState extends BaseState {
  DiaryModel diary;
  String? successMessage;
  DateTime selectedDate;
  DateTime focusedDate;
  bool isCompleted = false;
  bool isDraftSaved = false;
  bool isDraftSavedCompleted = false;
  bool isDraftPopUpShow = false;
  bool isEditMode = false;

  DiaryWriteState({
    required this.diary,
    super.isLoading = false,
    this.isCompleted = false,
    this.isDraftSaved = false,
    super.errorMessage,
    this.successMessage,
    this.isDraftPopUpShow = false,
    this.isDraftSavedCompleted = false,
    DateTime? selectedDate,
    DateTime? focusedDate,
    this.isEditMode = false,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       focusedDate = focusedDate ?? DateTime.now();

  DiaryWriteState copyWith({
    DiaryModel? diary,
    bool? isLoading,
    bool? isCompleted,
    bool? isDraftSaved,
    String? errorMessage,
    String? successMessage,
    bool? isDraftPopUpShow,
    DateTime? selectedDate,
    DateTime? focusedDate,
    bool? isDraftSavedCompleted,
    bool? isEditMode,
  }) {
    return DiaryWriteState(
      diary: diary ?? this.diary,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isDraftPopUpShow: isDraftPopUpShow ?? this.isDraftPopUpShow,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      isEditMode: isEditMode ?? this.isEditMode,
      isDraftSavedCompleted:
          isDraftSavedCompleted ?? this.isDraftSavedCompleted,
    );
  }
}
