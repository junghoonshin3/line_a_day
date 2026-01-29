import 'package:flutter/material.dart';

class ImagePickerSheetContent extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const ImagePickerSheetContent({
    super.key,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            '사진 추가하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              // color: Color(0xFF1F2937),
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
    );
  }
}

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
          // color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
