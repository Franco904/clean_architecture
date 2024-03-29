import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';
import 'package:clean_architecture/data/data.dart';
import 'package:clean_architecture/infra/infra.dart';

class MockClient extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late MockClient mockClient;
  late String url;

  setUp(() {
    mockClient = MockClient();
    url = faker.internet.httpUrl();

    sut = HttpHandlerAdapter(mockClient);
  });

  tearDown(() {
    reset(mockClient);
    resetMockitoState();
  });

  group('Shared', () {
    test('Deve retornar ServerError caso um método inválido seja provido', () async {
      final res = sut.request(url: url, method: 'invalid-method');

      expect(res, throwsA(HttpError.serverError));
    });
  });

  group('POST | ', () {
    PostExpectation mockExpectation({bool hasBody = false}) {
      return when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'), body: hasBody ? anyNamed('body') : null));
    }

    void mockHttpResponse(statusCode, {String responseBody = '{"any_key":"any_value"}', bool hasRequestBody = false}) {
      mockExpectation(hasBody: hasRequestBody).thenAnswer((_) async => Response(responseBody, statusCode));
    }

    void mockHttpError() => mockExpectation().thenThrow(Exception());

    setUp(() {
      // Padrão de mock/stub antes de cada teste de sucesso
      mockHttpResponse(200);
    });

    test('Deve chamar requisição POST com valores corretos', () {
      mockHttpResponse(200, hasRequestBody: true);

      sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Deve chamar requisição POST sem valor para o atributo body', () {
      sut.request(url: url, method: 'post');

      verify(mockClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
      ));
    });

    test('Deve retornar dados caso o status da requisição seja 200', () async {
      final res = await sut.request(url: url, method: 'post');

      expect(res, {'any_key': 'any_value'});
    });

    test('Deve retornar nulo caso o status da requisição seja 200 e retorne nenhum dado', () async {
      mockHttpResponse(200, responseBody: '');

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar nulo caso o status da requisição seja 204 e retorne nenhum dado', () async {
      mockHttpResponse(204, responseBody: '');

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar nulo caso o status da requisição seja 204 e retorne algum dado', () async {
      mockHttpResponse(204);

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar BadRequestError caso o status da requisição seja 400 com response body vazio', () async {
      mockHttpResponse(400, responseBody: '');

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.badRequest));
    });

    test('Deve retornar BadRequestError caso o status da requisição seja 400', () async {
      mockHttpResponse(400);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.badRequest));
    });

    test('Deve retornar UnauthorizedError caso o status da requisição seja 401', () async {
      mockHttpResponse(401);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.unauthorized));
    });

    test('Deve retornar ForbiddenError caso o status da requisição seja 403', () async {
      mockHttpResponse(403);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.forbidden));
    });

    test('Deve retornar NotFoundError caso o status da requisição seja 404', () async {
      mockHttpResponse(404);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.notFound));
    });

    test('Deve retornar ServerError caso o status da requisição seja 500', () async {
      mockHttpResponse(500);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.serverError));
    });

    test('Deve retornar ServerError caso a requisição retorne uma exceção', () async {
      mockHttpError();

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.serverError));
    });
  });
}
