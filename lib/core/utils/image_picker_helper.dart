import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';

class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: AppConstants.imageQuality,
    );
    return xfile != null ? File(xfile.path) : null;
  }

  static Future<File?> pickFromCamera() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: AppConstants.imageQuality,
    );
    return xfile != null ? File(xfile.path) : null;
  }

  static bool isWithinSizeLimit(File file) {
    return file.lengthSync() <= AppConstants.maxImageSizeBytes;
  }
}
