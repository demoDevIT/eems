import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  String blinkStatus = 'Detecting...';

  Future<XFile?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      compressionQuality: 30,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      print("filepath$filePath");
      int fileSize = await File(filePath).length(); // File size in bytes
      // if (fileSize > 1 * 1024 * 1024) {
      //   // 1 MB limit
      //   return null; // File too large
      // }
      return XFile(filePath);
    }
    return null;
  }
}
