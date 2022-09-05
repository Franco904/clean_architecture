import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/validation/validation.dart';

void main() {
  group('EmailFieldValidation | ', () {
    late EmailFieldValidation sut;

    setUp(() {
      sut = EmailFieldValidation('any_field');
    });

    tearDown(() {
      resetMockitoState();
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
  });
}
