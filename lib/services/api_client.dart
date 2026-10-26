import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ventur_2/config/api_config.dart';

/// Thrown for any API-level failure (network, timeout, non-2xx, bad JSON).
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin wrapper over `http` that handles JSON encode/decode, timeouts and
/// consistent error surfacing. One instance can be shared across repositories.
class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> getJson(String path, {Map<String, dynamic>? query}) async {
    final uri = ApiConfig.api(path, query);
    try {
      final res = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(ApiConfig.timeout);
      return _decode(res);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not reach the server. $e');
    }
  }

  Future<dynamic> putJson(String path, Object body) async {
    final uri = ApiConfig.api(path);
    try {
      final res = await _client
          .put(
            uri,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      return _decode(res);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not reach the server. $e');
    }
  }

  dynamic _decode(http.Response res) {
    final ok = res.statusCode >= 200 && res.statusCode < 300;
    dynamic parsed;
    if (res.body.isNotEmpty) {
      try {
        parsed = jsonDecode(res.body);
      } catch (_) {
        if (ok) throw const ApiException('Server returned invalid JSON.');
      }
    }
    if (!ok) {
      final msg = (parsed is Map && parsed['error'] is Map)
          ? (parsed['error']['message'] as String? ?? 'Request failed')
          : 'Request failed (${res.statusCode})';
      throw ApiException(msg, statusCode: res.statusCode);
    }
    return parsed;
  }

  void close() => _client.close();
}
