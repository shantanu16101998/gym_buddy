import 'dart:convert';
import 'dart:io';

class ImageConverter {
  static final ImageConverter constants = ImageConverter._();
  factory ImageConverter() => constants;
  ImageConverter._();
String convertToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return 'data:image/jpeg;base64,$base64Image';
  }
dynamic decodeBase64(String encoded) {
    String decoded = utf8.decode(base64Url.decode(encoded));
    return decoded;
  }
}