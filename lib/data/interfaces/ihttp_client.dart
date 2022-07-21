abstract class IHttpClient {
  Future<Map<String, dynamic>?> request({
    required String? url,
    required String? method,
    required Map<String, String>? body,
  });
}
