import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  /// Returns the image path if successful, null otherwise
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
      // Silently handle error and return null
      return null;
    }
  }

  /// Pick an image from the camera
  /// Returns the image path if successful, null otherwise
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
      // Silently handle error and return null
      return null;
    }
  }

  /// Pick multiple images from the gallery
  /// Returns list of image paths, empty list if error or no selection
  Future<List<String>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return images.map((image) => image.path).toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }
}