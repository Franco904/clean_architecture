import 'package:clean_architecture/domain/entities/account.dart';

abstract class Authentication {
  Future<Account> auth({
    required String email,
    required String password,
  });
}
