import 'package:line_a_day/features/diary/domain/model/diary_model.dart';

class DiaryWriteState {
  bool isLoading = false;
  DiaryModel diary;
  String? errorMessage;
  String? successMessage;
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
  });

  DiaryWriteState copyWith({
    DiaryModel? diary,
    bool? isLoading,
    bool? isCompleted,
    bool? isDraftSaved,
    bool? draftExists,
    String? errorMessage,
    String? successMessage,
    bool? isDraftPopUpShow,
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
    );
  }
}
