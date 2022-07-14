import 'package:clean_architecture/data/usecases/remote_authentication.dart';
import 'package:clean_architecture/domain/usecases/authentication.dart';
import '../../../mock/http_client_mock.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late RemoteAuthentication sut;
  late MockHttpClient mockHttpClient;
  late String url;

  setUp(() {
    mockHttpClient = MockHttpClient();

    url = faker.internet.httpUrl();

    // sut: "System under test" (classe sendo testada)
    sut = RemoteAuthentication(httpClient: mockHttpClient, url: url);
  });

  tearDown(() {
    reset(mockHttpClient);
    resetMockitoState();
  });

  test('Deve chamar o HttpClient com a URL correta', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    await sut.auth(params);

    verify(mockHttpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    ));
  });
}
