import 'dart:convert';

import 'package:cinema/data/core/api_constants.dart';
import 'package:cinema/data/core/unathorised_exception.dart';
import 'package:http/http.dart';


class ApiClient {
  final Client _client;

  ApiClient(this._client);

  /// GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    final response = await _client.get(
      getPath(path, params),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// POST request
  Future<dynamic> post(String path, {Map<String, dynamic>? params}) async {
    final response = await _client.post(
      getPath(path, null),
      body: params != null ? jsonEncode(params) : null,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// DELETE request with body
  Future<dynamic> deleteWithBody(String path, {Map<String, dynamic>? params}) async {
    final request = Request(
      'DELETE',
      getPath(path, null),
    );
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(params);

    final response = await _client.send(request).then(Response.fromStream);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Uri getPath(String path, Map<String, dynamic>? params) {
    final uri = Uri.parse('${ApiConstants.BASE_URL}$path');
    return uri.replace(
      queryParameters: {
        'api_key': ApiConstants.API_KEY,
        if (params != null) ...params,
      },
    );
  }
}