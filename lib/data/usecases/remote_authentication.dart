import '../../contracts/contracts.dart';
import '../../domain/domain.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class RemoteAuthentication implements Authentication {
  final HttpAdapter httpAdapter;
  final String url;

  RemoteAuthentication({
    required this.httpAdapter,
    required this.url,
  });

  @override
  Future<Account?> auth(AuthenticationParams params) async {
    try {
      final httpResponse = await httpAdapter.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );

      return httpResponse == null ? null : RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
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
