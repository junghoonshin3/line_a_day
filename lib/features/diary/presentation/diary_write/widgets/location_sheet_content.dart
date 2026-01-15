import 'package:flutter/material.dart';

class LocationSheetContent extends StatelessWidget {
  final String? initialLocation;
  final ValueChanged<String> onConfirm;

  const LocationSheetContent({
    super.key,
    this.initialLocation,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialLocation);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '위치 추가',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('특별한 장소를 기록해보세요', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 24),

              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '예: 서울 강남구 역삼동',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm(controller.text.trim());
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
