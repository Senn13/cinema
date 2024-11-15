import 'dart:convert';

import 'package:cinema/data/core/api_constants.dart';
import 'package:http/http.dart';

import 'dart:convert';
import 'package:http/http.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  /// Gửi yêu cầu GET tới API
  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    try {
      final response = await _client.get(
        Uri.parse(getPath(path, params)),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching data: $e');
    }
  }

  /// Xây dựng URL từ `path` và `params`
  String getPath(String path, Map<String, dynamic>? params) {
    final paramsString = params != null && params.isNotEmpty
        ? params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}').join('&')
        : '';

    return '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}${paramsString.isNotEmpty ? '&$paramsString' : ''}';
  }
}
