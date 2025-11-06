// core/services/image_picker_service.dart
import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // 카메라로 사진 촬영
  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      print('카메라 오류: $e');
      return null;
    }
  }

  // 갤러리에서 사진 선택
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      print('갤러리 오류: $e');
      return null;
    }
  }

  // 갤러리에서 여러 사진 선택
  Future<List<String>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      // 앱 세션이 종료된 경우 (이미지는 임시 cache폴더에 저장) 이미지가 사라지는 경우의 방어로직
      if (images.isEmpty) return [];
      final appDir = await getApplicationDocumentsDirectory(); // 영구 폴더
      final imageDir = Directory("${appDir.path}/images");
      // images 폴더 없으면 생성
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      final savedPaths = <String>[];

      for (final image in images) {
        // 중복 방지를 위해 타임스탬프 + 원본 이름
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final newPath = "${imageDir.path}/$fileName";

        // 원본 파일 복사
        final newFile = await File(image.path).copy(newPath);
        print(newFile.path);
        savedPaths.add(newFile.path);
      }

      return savedPaths;
    } catch (e) {
      print('다중 선택 오류: $e');
      return [];
    }
  }
}
