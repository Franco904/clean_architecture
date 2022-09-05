import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/validation/validation.dart';

void main() {
  group('EmailFieldValidation | ', () {
    late EmailFieldValidation sut;

    setUp(() {
      sut = EmailFieldValidation('any_field');
    });

    test('Deve retornar nulo se o email for vazio', () {
      expect(sut.validate(''), null);
    });

    test('Deve retornar nulo se o email for nulo', () {
      expect(sut.validate(null), null);
    });

    test('Deve retornar nulo se o email for válido', () {
      expect(sut.validate('franco.tavares@gmail.com'), null);
      expect(sut.validate('teste_123@tavares.eti.br'), null);
      expect(sut.validate('123456ASRS@fo.org'), null);
    });

    test('Deve retornar erro se o email for inválido', () {
      expect(sut.validate('franco tavares@gmail.com'), 'Email inválido');
      expect(sut.validate('teste_123'), 'Email inválido');
      expect(sut.validate('123456aSRS@fo34'), 'Email inválido');
    });
  });
}
