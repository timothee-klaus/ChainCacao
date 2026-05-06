import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> capturePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    return photo?.path;
  }

  Future<List<String>> pickMultipleImages() async {
    final List<XFile> photos = await _picker.pickMultiImage(
      imageQuality: 70,
    );
    return photos.map((p) => p.path).toList();
  }
}
