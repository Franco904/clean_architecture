abstract class HttpAdapter {
  Future<Map<String, dynamic>?> request({
    required String? url,
    required String? method,
    Map<String, String>? body,
  });
}
