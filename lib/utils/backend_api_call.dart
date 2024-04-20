import 'package:gym_buddy/constants/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> backendAPICall(String path,
    Map<String, String>? requestBody, String method, bool needJwt) async {
  Map<String, String> requestHeaders;

  if (needJwt) {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString("jwtToken") ?? "";

    requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': jwtToken,
    };
  } else {
    requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  if (method == "GET") {
    final response = await http.get(
      Uri.parse('$TEST_URL$path'),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "POST") {
    final response = await http.post(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "PUT") {
    final response = await http.put(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (method == "DELETE") {
    final response = await http.delete(
      Uri.parse('$TEST_URL$path'),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  return jsonDecode("") as Map<String, dynamic>;
}
