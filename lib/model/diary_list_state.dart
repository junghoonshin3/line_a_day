import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_a_day/model/diary_entity.dart';

class DiaryListState {
  final bool isLoading;
  List<DiaryEntity> diaryList;

  DiaryListState({required this.diaryList, this.isLoading = false});

  DiaryListState copyWith({
    List<DiaryEntity>? diaryList,
    bool? isLoading,
    Box<DiaryEntity>? box,
  }) {
    return DiaryListState(
      diaryList: diaryList ?? this.diaryList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
