import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockValidation extends Mock implements Validation {}

class MockAuthentication extends Mock implements Authentication {}

void main() {
  group('RequiredFieldValidation | ', () {
    late RequiredFieldValidation sut;

    setUp(() {
      sut = RequiredFieldValidation('any_field');
    });

    test('Deve retornar nulo se o valor passado não estiver vazio', () {
      final error = sut.validate('any_value');

      expect(error, null);
    });

    test('Deve retornar mensagem de erro se o valor passado estiver vazio', () {
      final error = sut.validate('');

      expect(error, 'Campo Obrigatório');
    });

    test('Deve retornar mensagem de erro se o valor passado for nulo', () {
      final error = sut.validate(null);

      expect(error, 'Campo Obrigatório');
    });
  });
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return value != null && value.isNotEmpty ? null : 'Campo Obrigatório';
  }
}

abstract class FieldValidation {
  String get field;

  String? validate(String value);
}
