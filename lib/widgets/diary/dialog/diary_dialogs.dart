import 'package:flutter/material.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/widgets/common/custom_calendar.dart';
import 'package:line_a_day/widgets/common/dialog/dialog_helper.dart';

class DiaryDialogs {
  // 사진 선택 바텀시트
  static void showImagePickerBottomSheet(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
    DialogHelper.showBottomSheetDialog(
      context,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text(
              '사진 추가하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ImagePickOption(
                    icon: Icons.camera_alt,
                    label: '카메라',
                    onTap: () {
                      Navigator.pop(context);
                      onCamera();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ImagePickOption(
                    icon: Icons.photo_library,
                    label: '갤러리',
                    onTap: () {
                      Navigator.pop(context);
                      onGallery();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 날씨 선택 다이얼로그
  static void showWeatherDialog(
    BuildContext context, {
    required Function(String) onWeatherSelected,
    String? currentWeather,
  }) {
    final weathers = [
      {'icon': '☀️', 'name': '맑음', 'value': 'sunny'},
      {'icon': '⛅', 'name': '구름 조금', 'value': 'partly_cloudy'},
      {'icon': '☁️', 'name': '흐림', 'value': 'cloudy'},
      {'icon': '🌧️', 'name': '비', 'value': 'rainy'},
      {'icon': '⛈️', 'name': '천둥번개', 'value': 'thunderstorm'},
      {'icon': '❄️', 'name': '눈', 'value': 'snowy'},
      {'icon': '🌫️', 'name': '안개', 'value': 'foggy'},
      {'icon': '🌪️', 'name': '바람', 'value': 'windy'},
    ];
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '오늘의 날씨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '오늘 날씨를 선택해주세요',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: weathers.length,
                itemBuilder: (context, index) {
                  final weather = weathers[index];
                  final isSelected = currentWeather == weather['value'];
                  return GestureDetector(
                    onTap: () {
                      onWeatherSelected(weather['value'] as String);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3B82F6).withOpacity(0.1)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather['icon'] as String,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weather['name'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              if (currentWeather != null)
                TextButton(
                  onPressed: () {
                    onWeatherSelected('');
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '선택 해제',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 위치 추가 바텀시트
  static void showLocationBottomSheet(
    BuildContext context, {
    required Function(String) onLocationAdded,
    String? currentLocation,
  }) {
    final TextEditingController controller = TextEditingController(
      text: currentLocation ?? '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '위치 추가',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '특별한 장소를 기록해보세요',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '예: 서울 강남구 역삼동',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Color(0xFF3B82F6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.clear();
                          onLocationAdded('');
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            onLocationAdded(controller.text.trim());
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showCalendarDialog({
    required BuildContext context,
    required DateTime focusedDate,
    required DateTime? selectedDate,
    required void Function(DateTime selectedDay, DateTime focusedDay)
    onDaySelected,
    required void Function(DateTime focusedDay) onPageChanged,
    required bool Function(DateTime date) hasEntryOnDate,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '날짜 선택',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '날짜를 선택해주세요',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              CalendarWidget(
                focusedDate: focusedDate,
                selectedDate: selectedDate,
                onDaySelected: (selectedDay, focusedDay) {
                  onDaySelected(selectedDay, focusedDay);
                  Navigator.pop(context); // 날짜 선택 시 다이얼로그 닫기
                },
                onPageChanged: onPageChanged,
                hasEntryOnDate: hasEntryOnDate,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 태그 추가 다이얼로그
  static void showTagDialog(
    BuildContext context, {
    required Function(List<String>) onTagsUpdated,
    required List<String> currentTags,
  }) {
    final TextEditingController controller = TextEditingController();
    List<String> tags = List.from(currentTags);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '태그 추가',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '키워드로 일기를 분류해보세요',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: '태그 입력',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: const Icon(
                            Icons.tag,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty &&
                              !tags.contains(value.trim())) {
                            setState(() {
                              tags.add(value.trim());
                              controller.clear();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty &&
                            !tags.contains(controller.text.trim())) {
                          setState(() {
                            tags.add(controller.text.trim());
                            controller.clear();
                          });
                        }
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (tags.isNotEmpty) ...[
                  const Text(
                    '추가된 태그',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200, // 태그 영역 최대 높이
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                tags.remove(tag);
                              });
                            },
                            backgroundColor: const Color(
                              0xFF3B82F6,
                            ).withOpacity(0.1),
                            labelStyle: const TextStyle(
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w500,
                            ),
                            deleteIconColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onTagsUpdated(tags);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 감정 선택 다이얼로그
  static void showEmotionDialog(
    BuildContext context, {
    required Function(Emotion) onEmotionSelected,
    EmotionType? currentEmotion,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.sentiment_satisfied_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('오늘의 감정', style: AppTheme.headlineMedium),
                        const SizedBox(height: 2),
                        Text(
                          '지금 느끼는 감정을 선택해주세요',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.gray400),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 감정 그리드
              SizedBox(
                height: 420,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: Emotion.emotions.length,
                  itemBuilder: (context, index) {
                    final emotion = Emotion.emotions[index];
                    final isSelected = currentEmotion == emotion.type;

                    return GestureDetector(
                      onTap: () {
                        onEmotionSelected(emotion);
                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.gray100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppTheme.gray200,
                            width: isSelected ? 0 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Color(
                                      emotion.colorCode,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emotion.emoji,
                              style: TextStyle(fontSize: isSelected ? 42 : 38),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              emotion.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.gray700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// 사진 선택 옵션 위젯
class _ImagePickOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImagePickOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: const Color(0xFF3B82F6)),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
