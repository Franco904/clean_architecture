import '../../../domain/domain.dart';

abstract class Authentication {
  Future<Account?> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });
}
