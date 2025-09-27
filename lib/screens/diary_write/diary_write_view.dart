import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/model/diary_entity.dart';
import 'package:line_a_day/screens/diary_write/diary_write_view_model.dart';
import 'package:line_a_day/widgets/line_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' as foundation;

class DiaryWriteView extends ConsumerStatefulWidget {
  const DiaryWriteView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends ConsumerState<DiaryWriteView> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      ref
          .read(diaryWriteViewModelProvider.notifier)
          .onChangedText(_contentController.text);
    });
    _titleController.addListener(() {
      ref
          .read(diaryWriteViewModelProvider.notifier)
          .onChangedTitle(_titleController.text);
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryWriteViewModelProvider);
    final viewModel = ref.read(diaryWriteViewModelProvider.notifier);
    final today = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text("${today.year}-${today.month}-${today.day}"),
        actions: [
          IconButton(
            iconSize: 28,
            onPressed: () {
              viewModel.saveDiary(
                DiaryEntity(
                  id: const Uuid().v1(),
                  title: state.title,
                  content: state.text,
                  date: DateTime.now(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check_box_outlined, color: Colors.black),
          ),
          IconButton(
            iconSize: 28,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LineCalendarWidget(
                            focusedDay: DateTime.now(),
                            selectedDay: DateTime.now(),
                            isExpanded: true,
                            onDaySelected: (p1, p2) {},
                            onPageChanged: (p1) {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.black),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          _titleFocusNode.unfocus();

          _contentFocusNode.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    autocorrect: false,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 1,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: '제목'),
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _contentController,
                    focusNode: _contentFocusNode,
                    autocorrect: false,
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 10,
                    decoration: const InputDecoration(hintText: '내용'),
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 30),
                  // const Text("느낀 감정들"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
