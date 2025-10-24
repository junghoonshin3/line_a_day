// core/services/image_picker_service.dart
import 'package:image_picker/image_picker.dart';

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
      return images.map((image) => image.path).toList();
    } catch (e) {
      print('다중 선택 오류: $e');
      return [];
    }
  }
}
