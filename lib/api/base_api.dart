import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:notepad/api/api_exception.dart';

class BaseApi {
  final _client = http.Client();

  Future<String> get(String url) async => _request(() => _client.get(url));

  Future<String> post(String url, String data) async => _request(() => _client.post(url, body: data));

  Future<String> put(String url, String data) async => _request(() => _client.put(url, body: data));

  Future<String> delete(String url) async => _request(() => _client.delete(url));

  Future<String> _request(Future<http.Response> Function() httpCall) async {
    try {
      final response = await httpCall();
      return response.body;
    } on SocketException {
      throw ApiConnectionException();
    }
  }

  void dispose() {
    _client.close();
  }
}

extension FromJsonTransform on Future<String> {
  Future<Map<String, dynamic>> fromJson() async {
    try {
      return json.decode(await this) as Map<String, dynamic> ?? {};
    } catch (e) {
      throw ApiDataException(e);
    }
  }
}

T tryToParse<T>(T Function() parse) {
  try {
    return parse();
  }
  catch(e) {
    throw ApiDataException(e);
  }
}
