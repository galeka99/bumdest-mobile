import 'dart:convert';

import 'package:bumdest/services/config.dart';
import 'package:bumdest/services/error_parser.dart';
import 'package:bumdest/services/store.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<dynamic> get(String path, {bool auth = true}) async {
    try {
      String url = '${config.hostApi}$path';
      Map<String, String> headers = {};
      if (auth) headers['Authorization'] = 'Bearer ${store.token}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        dynamic data = json.decode(response.body);
        throw ApiError(
          code: data['status'],
          message: ErrorParser.parse(data['error']),
        );
      }
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(code: 500, message: 'Error while fetching data');
    }
  }

  static Future<dynamic> post(
    String path, {
    bool auth = true,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      String url = '${config.hostApi}$path';
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (auth) headers['Authorization'] = 'Bearer ${store.token}';
      http.Response response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(data));

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        dynamic data = json.decode(response.body);
        throw ApiError(
          code: data['status'],
          message: ErrorParser.parse(data['error']),
        );
      }
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(code: 500, message: 'Error while sending data to server');
    }
  }
}

class ApiError {
  final int code;
  final String message;

  ApiError({
    required this.code,
    required this.message,
  });
}
