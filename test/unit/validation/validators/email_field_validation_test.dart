import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/validation/validation.dart';

void main() {
  group('EmailFieldValidation | ', () {
    setUp(() {});

    tearDown(() {
      resetMockitoState();
    });

    test('Deve retornar nulo se o email for vazio', () {
      final sut = EmailFieldValidation('any_field');

      final error = sut.validate('');

      expect(error, null);
    });
  });
}
