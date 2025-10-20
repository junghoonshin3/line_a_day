import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

class DiaryWriteState {
  bool isLoading = false;
  DiaryModel diary;
  String? errorMessage;
  String? successMessage;
  DateTime selectedDate;
  DateTime focusedDate;
  bool isCompleted = false;
  bool isDraftSaved = false;
  bool draftExists = false;
  bool isDraftPopUpShow = false;

  DiaryWriteState({
    required this.diary,
    this.isLoading = false,
    this.isCompleted = false,
    this.isDraftSaved = false,
    this.draftExists = false,
    this.errorMessage,
    this.successMessage,
    this.isDraftPopUpShow = false,
    DateTime? selectedDate,
    DateTime? focusedDate,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       focusedDate = focusedDate ?? DateTime.now();

  DiaryWriteState copyWith({
    DiaryModel? diary,
    bool? isLoading,
    bool? isCompleted,
    bool? isDraftSaved,
    bool? draftExists,
    String? errorMessage,
    String? successMessage,
    bool? isDraftPopUpShow,
    DateTime? selectedDate,
    DateTime? focusedDate,
  }) {
    return DiaryWriteState(
      diary: diary ?? this.diary,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      draftExists: draftExists ?? this.draftExists,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isDraftPopUpShow: isDraftPopUpShow ?? this.isDraftPopUpShow,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
    );
  }
}
