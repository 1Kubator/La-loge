import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileCompressor {
  static Future<File> compressImg(File file) async {
    final tempDir = await getApplicationDocumentsDirectory();
    var imgFormat = file.path.split('.').last;
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempDir.path + '.$imgFormat',
      quality: 70,
    );
    return result;
  }
}
