import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../mock/http/client_mock.dart';

void main() {
  group('POST | ', () {
    late HttpAdapter sut;
    late MockClient mockClient;
    late String url;

    setUp(() {
      mockClient = MockClient();
      url = faker.internet.httpUrl();

      sut = HttpAdapter(mockClient);
    });

    tearDown(() {
      reset(mockClient);
      resetMockitoState();
    });

    test('Deve chamar requisição POST com valores corretos', () {
      // ignore: prefer_single_quotes
      sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: '{"any_key":"any_value"}'
      ));
    });

    test('Deve chamar requisição POST sem valor para o atributo body', () {
      sut.request(url: url, method: 'post');

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
      ));
    });
  });
}

class HttpAdapter {
  Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String? url,
    required String? method,
    Map<String, String>? body,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    client.post(Uri.parse(url!), headers: headers, body: jsonBody);
  }
}
