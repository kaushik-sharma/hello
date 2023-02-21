import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageHelpers {
  static Future<File> convertUrlToFile(String url) async {
    final responseData = await http.get(Uri.parse(url));
    final bytebuffer = responseData.bodyBytes.buffer;
    final byteData = ByteData.view(bytebuffer);
    final tempDir = await path_provider.getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}';
    return await File(filePath).writeAsBytes(
      bytebuffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
  }
}
