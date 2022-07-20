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
      sut.request(url: url, method: 'post');

      verify(mockClient.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}));
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
    final headers = {'Content-Type': 'application/json'};

    client.post(Uri.parse(url!), headers: headers);
  }
}
