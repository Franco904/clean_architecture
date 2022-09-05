import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';
import 'package:clean_architecture/validation/validation.dart';

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {
  group('ValidationComposite | ', () {
    late MockFieldValidation mockFieldValidation1;
    late MockFieldValidation mockFieldValidation2;
    late MockFieldValidation mockFieldValidation3;

    late ValidationComposite sut;

    void mockValidation1(String? value) => when(mockFieldValidation1.validate('any_value')).thenReturn(value);
    void mockValidation2(String? value) => when(mockFieldValidation2.validate('any_value')).thenReturn(value);
    void mockValidation3(String? value) => when(mockFieldValidation3.validate('any_value')).thenReturn(value);

    setUp(() {
      mockFieldValidation1 = MockFieldValidation();
      mockFieldValidation2 = MockFieldValidation();
      mockFieldValidation3 = MockFieldValidation();

      sut = ValidationComposite([mockFieldValidation1, mockFieldValidation2, mockFieldValidation3]);

      when(mockFieldValidation1.field).thenReturn('any_field');
      when(mockFieldValidation2.field).thenReturn('other_field');
      when(mockFieldValidation3.field).thenReturn('any_field');
    });

    tearDown(() {
      resetMockitoState();
    });

    test('Deve retornar nulo caso todos os validadores retornem nulo ou vazio', () {
      mockValidation1(null);
      mockValidation2('');
      mockValidation3(null);

      expect(sut.validate(field: 'any_field', value: 'any_value'), null);
    });

    test('Deve retornar primeiro erro encontrado dos validadores', () {
      mockValidation1('error_1');
      mockValidation2('error_2');
      mockValidation3('error_3');

      expect(sut.validate(field: 'any_field', value: 'any_value'), 'error_1');
      expect(sut.validate(field: 'other_field', value: 'any_value'), 'error_2');
    });
  });
}
