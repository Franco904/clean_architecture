import 'dart:convert';
import 'package:http/http.dart';

import '../../contracts/contracts.dart';
import '../../data/data.dart';

class HttpHandlerAdapter implements HttpAdapter {
  Client client;

  HttpHandlerAdapter(this.client);

  @override
  Future<Map<String, dynamic>?> request({
    required String? url,
    required String? method,
    Map<String, String>? body,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    Response res = Response('', 500);

    try {
      switch (method) {
        case 'post':
          res = await client.post(Uri.parse(url!), headers: headers, body: jsonBody);
          break;
      }
    } catch (_) {
      throw HttpError.serverError;
    }

    return _checkResponseAndReturn(res);
  }

  Map<String, dynamic>? _checkResponseAndReturn(Response res) {
    if (res.statusCode == 204) return null;
    if (res.statusCode == 200) return res.body.isEmpty ? null : jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode == 400) throw HttpError.badRequest;
    if (res.statusCode == 401) throw HttpError.unauthorized;
    if (res.statusCode == 403) throw HttpError.forbidden;
    if (res.statusCode == 404) throw HttpError.notFound;

    throw HttpError.serverError;
  }
}
