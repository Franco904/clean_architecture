abstract class IHttpClient {
  Future<void> request({
    required String? url,
    required String? method,
    required Map<String, String>? body,
  });
}
