import 'package:clean_architecture/data/interfaces/interfaces.dart';
import 'package:clean_architecture/data/utils/utils.dart';
import 'package:clean_architecture/domain/usecases/usecases.dart';
import 'package:clean_architecture/domain/utils/domain_errors.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    try {
      await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
    } on HttpError {
      throw DomainErrors.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(email: params.email, password: params.password);
  }

  Map<String, String> toJson() => {'email': email, 'password': password};
}
