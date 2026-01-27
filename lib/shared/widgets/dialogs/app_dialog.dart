import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;

  const AppDialog({super.key, this.title, required this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- 상단 헤더 영역 (X 버튼 + 타이틀) ---
            Stack(
              alignment: Alignment.center,
              children: [
                // 1. 왼쪽 X 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                // 2. 중앙 타이틀
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            /// 🔥 핵심 콘텐츠
            content,

            // --- 하단 액션 버튼 영역 (필요 시) ---
            if (actions != null) ...[
              const SizedBox(height: 24),
              Row(children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}
