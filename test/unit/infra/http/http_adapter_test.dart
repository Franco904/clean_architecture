import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../mock/http/client_mock.dart';
import 'package:clean_architecture/data/utils/utils.dart';
import 'package:clean_architecture/infra/http/http.dart';

void main() {
  group('POST | ', () {
    late HttpAdapter sut;
    late MockClient mockClient;
    late String url;

    PostExpectation mockExpectation({bool hasBody = false}) {
      return when(mockClient.post(Uri.parse(url), headers: anyNamed('headers'), body: hasBody ? anyNamed('body') : null));
    }

    void mockHttpResponse(statusCode, {String responseBody = '{"any_key":"any_value"}', bool hasRequestBody = false}) {
      mockExpectation(hasBody: hasRequestBody).thenAnswer((_) async => Response(responseBody, statusCode));
    }

    setUp(() {
      mockClient = MockClient();
      url = faker.internet.httpUrl();

      sut = HttpAdapter(mockClient);

      // Padrão de mock/stub antes de cada teste de sucesso
      mockHttpResponse(200);
    });

    tearDown(() {
      reset(mockClient);
      resetMockitoState();
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

    test('Deve retornar dados caso status da requisição seja 200', () async {
      final res = await sut.request(url: url, method: 'post');

      expect(res, {'any_key': 'any_value'});
    });

    test('Deve retornar nulo caso status da requisição seja 200 e retorne nenhum dado', () async {
      mockHttpResponse(200, responseBody: '');

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar nulo caso status da requisição seja 204 e retorne nenhum dado', () async {
      mockHttpResponse(204, responseBody: '');

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar nulo caso status da requisição seja 204 e retorne algum dado', () async {
      mockHttpResponse(204);

      final res = await sut.request(url: url, method: 'post');

      expect(res, null);
    });

    test('Deve retornar BadRequestError caso status da requisição seja 400 com response body vazio', () async {
      mockHttpResponse(400, responseBody: '');

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.badRequest));
    });

    test('Deve retornar BadRequestError caso status da requisição seja 400', () async {
      mockHttpResponse(400);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.badRequest));
    });

    test('Deve retornar UnauthorizedError caso status da requisição seja 401', () async {
      mockHttpResponse(401);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.unauthorized));
    });

    test('Deve retornar ServerError caso status da requisição seja 500', () async {
      mockHttpResponse(500);

      final res = sut.request(url: url, method: 'post');

      expect(res, throwsA(HttpError.serverError));
    });
  });
}
