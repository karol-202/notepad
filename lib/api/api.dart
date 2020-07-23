import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:notepad/api/api_exception.dart';

Future<dynamic> get(String url) async => _request(() => http.get(url));

Future<dynamic> post(String url, String data) async => _request(() => http.post(url, body: data));

Future<dynamic> put(String url, String data) async => _request(() => http.put(url, body: data));

Future<dynamic> delete(String url) async => _request(() => http.delete(url));

Future<dynamic> _request(Future<http.Response> Function() httpCall) async {
  try {
    final response = await httpCall();
    return json.decode(response.body);
  }
  on SocketException {
    throw ApiConnectionException();
  }
}
