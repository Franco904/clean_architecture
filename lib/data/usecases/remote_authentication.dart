import 'package:clean_architecture/data/interfaces/interfaces.dart';
import 'package:clean_architecture/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: params.toJson(),
    );
  }
}