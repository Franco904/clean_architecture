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

    PostExpectation mockExpectation() => when(mockHttpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

    void mockHttpData(Map<String, dynamic> data) => mockExpectation().thenAnswer((_) async => data);

    void mockHttpError(HttpError httpError) => mockExpectation().thenThrow(httpError);

    // Padrão para respostas http com sucesso
    Map<String, dynamic> validMockData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

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
      mockHttpData(validMockData());

      await sut.auth(params);

      verify(mockHttpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 400', () async {
      mockHttpError(HttpError.badRequest);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.unexpected));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 404', () async {
      mockHttpError(HttpError.notFound);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.unexpected));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 500', () async {
      mockHttpError(HttpError.serverError);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.unexpected));
    });

    test('Deve retornar InvalidCredentialsError se o HttpClient responder 401', () async {
      mockHttpError(HttpError.unauthorized);

      final res = sut.auth(params);

      expect(res, throwsA(DomainErrors.invalidCredentials));
    });

    test('Deve retornar um objeto Account se o HttpClient responder 200', () async {
      final validData = validMockData();
      mockHttpData(validData);

      final account = await sut.auth(params);

      expect(account.token, validData['accessToken']);
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 200 com dados inválidos', () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      final account = sut.auth(params);

      expect(account, throwsA(DomainErrors.unexpected));
    });
  });
}
