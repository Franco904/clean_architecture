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
      final error = sut.validate('');

      expect(error, null);
    });

    test('Deve retornar nulo se o email for nulo', () {
      final error = sut.validate(null);

      expect(error, null);
    });
  });
}
