import 'package:file_picker/file_picker.dart' show FilePickerResult, FileType, FilePicker;
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

class MultimediaUtils {
  static Future<List<SelectedMedia>> pickFromFile({
    OnErrorReceived? onError,
    bool onlyVideo = false,
    bool onlyPhoto = true,
    String title = "",
    SelectedMediaListReceived? handleSelected,
    bool multipleAllowed = false
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: onlyVideo ? FileType.video : onlyPhoto ? FileType.image : FileType.media,
        allowMultiple: multipleAllowed,
        dialogTitle: title
      );

      if(result.isNotNull && result!.files.isNotEmpty) {
        if(result.files.all((file) => (file.path ?? file.name).isImage || (file.path ?? file.name).isVideo)) {
          List<SelectedMedia> files = result.files.map((file) {
            String path = file.path ?? file.name;

            return SelectedMedia(
              path: path,
              data: file.bytes,
              size: file.size.toFileSize,
              media: path.isVideo ? MediaType.video : MediaType.photo,
            );
          }).toList();

          if(handleSelected.isNotNull) {
            handleSelected!(files);
          }

          return files;
        }

        if(onError.isNotNull) {
          onError!("Unsupported file format detected. Only images or videos are allowed", true);
        }
      }
    } catch (e) {
      if(onError.isNotNull) {
        onError!("Unsupported file format.", true);
      }
    }

    return [];
  }
}