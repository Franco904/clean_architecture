import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/validation/validation.dart';

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
