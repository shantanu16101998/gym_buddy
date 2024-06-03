import 'package:gym_buddy/constants/url.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadImage(
    String path, XFile imageFile, String customerId) async {
  try {
    var sharedPreferences = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', Uri.parse('$TEST_URL$path'));
    var jwtToken = sharedPreferences.getString("jwtToken") ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvd25lcklkIjoiNjY1MzNmN2QyYTI0YTI5NjBkMjkyMjA1IiwiY29udGFjdCI6IjcwNjU1ODQ3NzgiLCJpYXQiOjE3MTY3OTQ4MzgsImV4cCI6MzYwMDE3MTY3OTQ4Mzh9.TWUnAF5HuJrQS8zG-hxpzlpF1iE2RaSgDegwZGx9JCc";
    request.headers['token'] = jwtToken;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));
    request.fields['customerId'] = customerId;
    await request.send();
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<Map<String, dynamic>> backendAPICall(String path,
    Map<String, dynamic>? requestBody, String method, bool needJwt) async {
  Map<String, String> requestHeaders;

  print('calling $TEST_URL$path');
  print('');
  print('request body $requestBody');
  print('');
  print('method: $method');
  print('');

/*
  SAMPLE JWT TOKEN FOR DEVELOPING

  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvd25lck5hbWUiOiJhYmNkIiwiZW1haWwiOiJhYmNkIiwiY29udGFjdCI6IjEyMzEyMzEyMzIxMyIsImlhdCI6MTcxNDU3NzAwNywiZXhwIjozNjAwMTcxNDU3NzAwN30.r3XhAUNTI5kKDxNaacUoCL6djMxudDHSwJWv6ni_Y_I"
*/

  if (needJwt) {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString("jwtToken") ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvd25lcklkIjoiNjY1ZDhiNzIwYjdkMjVjNzgxZDE3M2RiIiwiY29udGFjdCI6IjExMTExMTExMTEiLCJpYXQiOjE3MTc0MDY2MDQsImV4cCI6MzYwMDE3MTc0MDY2MDR9.8x5dXDXSAqt95efhojIOfFlLCIp4UIxrM6SwABumxcQ";
    requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'token': jwtToken,
    };
  } else {
    requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // print('request headers $requestHeaders');

  if (method == "GET") {
    final response = await http.get(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
    );
    print(response.body);
    print('');

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "POST") {
    final response = await http.post(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );
    print(response.body);
    print('');

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "PUT") {
    final response = await http.put(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );
    // print(response.body);
    // print('');
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "DELETE") {
    final response =
        await http.delete(Uri.parse('$TEST_URL$path'), headers: requestHeaders);

    // print(response.body);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  return jsonDecode("") as Map<String, dynamic>;
}
