import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';
import 'package:clean_architecture/data/data.dart';
import 'package:clean_architecture/domain/domain.dart';

class MockHttpAdapter extends Mock implements HttpAdapter {}

void main() {
  group('RemoteAuthentication | ', () {
    late RemoteAuthentication sut;
    late AuthenticationParams params;
    late MockHttpAdapter mockHttpAdapter;
    late String url;

    PostExpectation mockExpectation() => when(mockHttpAdapter.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

    void mockHttpData(Map<String, dynamic> data) => mockExpectation().thenAnswer((_) async => data);

    void mockHttpError(HttpError httpError) => mockExpectation().thenThrow(httpError);

    void mockHttpNullReturn() => mockExpectation().thenAnswer((_) => null);

    // Padrão para respostas http com sucesso
    Map<String, dynamic> validMockData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

    setUp(() {
      mockHttpAdapter = MockHttpAdapter();
      url = faker.internet.httpUrl();

      // sut: "System under test" (classe sendo testada)
      sut = RemoteAuthentication(httpAdapter: mockHttpAdapter, url: url);

      params = AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
    });

    tearDown(() {
      reset(mockHttpAdapter);
      resetMockitoState();
    });

    test('Deve chamar o HttpClient com a URL correta', () async {
      mockHttpData(validMockData());

      await sut.auth(params);

      verify(mockHttpAdapter.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 400', () async {
      mockHttpError(HttpError.badRequest);

      final res = sut.auth(params);

      expect(res, throwsA(DomainError.unexpected));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 404', () async {
      mockHttpError(HttpError.notFound);

      final res = sut.auth(params);

      expect(res, throwsA(DomainError.unexpected));
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 500', () async {
      mockHttpError(HttpError.serverError);

      final res = sut.auth(params);

      expect(res, throwsA(DomainError.unexpected));
    });

    test('Deve retornar InvalidCredentialsError se o HttpClient responder 401', () async {
      mockHttpError(HttpError.unauthorized);

      final res = sut.auth(params);

      expect(res, throwsA(DomainError.invalidCredentials));
    });

    test('Deve retornar um objeto Account se o HttpClient responder 200', () async {
      final validData = validMockData();
      mockHttpData(validData);

      final account = (await sut.auth(params))!;

      expect(account.token, validData['accessToken']);
    });

    test('Deve retornar UnexpectedError se o HttpClient responder 200 com dados inválidos', () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      final account = sut.auth(params);

      expect(account, throwsA(DomainError.unexpected));
    });

    test('Deve retornar nulo se o HttpClient responder 200 sem dados retornados', () async {
      mockHttpNullReturn();

      final account = await sut.auth(params);

      expect(account, null);
    });
  });
}
