/// Centralised API configuration.
///
/// Override the base URL at build/run time without touching code:
///
///   flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com
///
/// Platform notes for local development:
///   * Android emulator  -> http://10.0.2.2:3000  (host loopback)
///   * iOS simulator     -> http://localhost:3000
///   * Real device       -> http://<your-machine-LAN-IP>:3000
class ApiConfig {
  const ApiConfig._();

  /// Base origin of the backend, e.g. `http://localhost:3000`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Versioned API prefix. Must match the server's `API_PREFIX`.
  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '/api/v1',
  );

  /// Network timeout for API calls.
  static const Duration timeout = Duration(seconds: 15);

  static Uri api(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$apiPrefix$normalized').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }
}
