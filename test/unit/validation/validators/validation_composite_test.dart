import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {
  group('ValidationComposite | ', () {
    late MockFieldValidation mockFieldValidation1;
    late MockFieldValidation mockFieldValidation2;
    late ValidationComposite sut;

    setUp(() {
      mockFieldValidation1 = MockFieldValidation();
      mockFieldValidation2 = MockFieldValidation();

      sut = ValidationComposite([mockFieldValidation1, mockFieldValidation2]);
    });

    tearDown(() {
      resetMockitoState();
    });

    test('Deve retornar nulo caso todos os validadores retornem nulo ou vazio', () {
      when(mockFieldValidation1.field).thenReturn('any_field');
      when(mockFieldValidation1.validate('any_value')).thenReturn(null);

      when(mockFieldValidation2.field).thenReturn('any_field');
      when(mockFieldValidation2.validate('any_value')).thenReturn('');

      expect(sut.validate(field: 'any_field', value: 'any_value'), null);
    });
  });
}

class ValidationComposite {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String? validate({required String? field, required String? value}) {
    return null;
  }
}
