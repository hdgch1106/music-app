import 'package:file_picker/file_picker.dart';
import 'package:music_app/core/core.dart';

class FilePickerServiceImpl extends FilePickerService {
  @override
  Future<String?> getDirectoryPath() async {
    final result = await FilePicker.platform.getDirectoryPath();

    return result;
  }
}
