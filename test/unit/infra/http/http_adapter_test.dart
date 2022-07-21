import 'dart:convert';

import 'package:clean_architecture/data/interfaces/ihttp_client.dart';
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
      when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      // ignore: prefer_single_quotes
      sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Deve chamar requisição POST sem valor para o atributo body', () {
      when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      sut.request(url: url, method: 'post');

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
      ));
    });

    test('Deve retornar dados caso status da requisição seja 200', () async {
      when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      final res = await sut.request(url: url, method: 'post');

      expect(res, {'any_key': 'any_value'});
    });

    test('Deve retornar nulo caso status da requisição seja 200 e retorne nenhum dado', () async {
      when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 200));

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });
  });
}

class HttpAdapter implements IHttpClient {
  Client client;

  HttpAdapter(this.client);

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

    final res = await client.post(Uri.parse(url!), headers: headers, body: jsonBody);

    return res.body.isEmpty ? null : jsonDecode(res.body) as Map<String, dynamic>;
  }
}
