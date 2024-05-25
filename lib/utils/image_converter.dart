import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

String convertToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return 'data:image/jpeg;base64,$base64Image';
  }

File decodeBase64ToFile(String encoded) {
  List<int> bytes = base64.decode(encoded);
  Uint8List uint8List = Uint8List.fromList(bytes);
  return File.fromRawPath(uint8List);
}
