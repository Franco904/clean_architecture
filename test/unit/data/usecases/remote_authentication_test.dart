import 'package:clean_architecture/data/usecases/remote_authentication.dart';
import 'package:clean_architecture/data/utils/utils.dart';
import 'package:clean_architecture/domain/usecases/usecases.dart';
import 'package:clean_architecture/domain/utils/utils.dart';
import '../../../mock/http_client_mock.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('RemoteAuthentication | ', () {
    late RemoteAuthentication sut;
    late AuthenticationParams params;
    late MockHttpClient mockHttpClient;
    late String url;

    setUp(() {
      mockHttpClient = MockHttpClient();
      url = faker.internet.httpUrl();

      // sut: "System under test" (classe sendo testada)
      sut = RemoteAuthentication(httpClient: mockHttpClient, url: url);

      params = AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
    });

    tearDown(() {
      reset(mockHttpClient);
      resetMockitoState();
    });

    test('Deve chamar o HttpClient com a URL correta', () async {
      await sut.auth(params);

      verify(mockHttpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 400', () async {
      when(mockHttpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.badRequest);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.unexpected));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 404', () async {
      when(mockHttpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.notFound);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.unexpected));
    });
  });
}
