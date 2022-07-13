import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import '../../../mock/http_client_mock.dart';

void main() {
  late RemoteAuthentication sut;
  late MockHttpClient http;
  late String url;

  setUp(() {
    http = MockHttpClient();
    url = faker.internet.httpUrl();

    // sut: "System under test" (classe sendo testada)
    sut = RemoteAuthentication(http: http, url: url);
  });

  test('Deve chamar o HttpClient com a URL correta', () async {
    await sut.auth();

    verify(http.request(url: url, method: 'post'));
  });
}

abstract class IHttpClient {
  Future<void> request({
    required String url,
    required String method,
  });
}

class RemoteAuthentication {
  final IHttpClient http;
  final String url;

  RemoteAuthentication({
    required this.http,
    required this.url,
  });

  Future<void> auth() async {
    await http.request(url: url, method: 'post');
  }
}
