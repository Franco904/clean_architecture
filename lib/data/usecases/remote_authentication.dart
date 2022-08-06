import 'package:clean_architecture/data/interfaces/interfaces.dart';
import 'package:clean_architecture/data/models/models.dart';
import 'package:clean_architecture/data/utils/utils.dart';

import 'package:clean_architecture/domain/entities/entities.dart';
import 'package:clean_architecture/domain/usecases/usecases.dart';
import 'package:clean_architecture/domain/utils/domain_errors.dart';

class RemoteAuthentication implements Authentication {
  final IHttpAdapter httpAdapter;
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
      throw error == HttpError.unauthorized ? DomainErrors.invalidCredentials : DomainErrors.unexpected;
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
