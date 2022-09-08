import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

abstract class Authentication {
  Future<Account?> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  const AuthenticationParams({
    required this.email,
    required this.password,
  });

  @override
  List get props => [email, password];
}
