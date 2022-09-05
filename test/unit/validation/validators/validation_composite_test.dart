import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {
  group('ValidationComposite | ', () {
    late MockFieldValidation mockFieldValidation1;
    late MockFieldValidation mockFieldValidation2;
    late MockFieldValidation mockFieldValidation3;

    late ValidationComposite sut;

    void mockValidation1(String? value) => when(mockFieldValidation1.validate('any_value')).thenReturn(value);
    void mockValidation2(String? value) => when(mockFieldValidation2.validate('other_value')).thenReturn(value);
    void mockValidation3(String? value) => when(mockFieldValidation2.validate('another_value')).thenReturn(value);

    setUp(() {
      mockFieldValidation1 = MockFieldValidation();
      mockFieldValidation2 = MockFieldValidation();
      mockFieldValidation3 = MockFieldValidation();

      sut = ValidationComposite([mockFieldValidation1, mockFieldValidation2, mockFieldValidation3]);

      when(mockFieldValidation1.field).thenReturn('any_field');
      when(mockFieldValidation2.field).thenReturn('other_value');
      when(mockFieldValidation3.field).thenReturn('another_value');
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
  });
}

class ValidationComposite {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String? validate({required String? field, required String? value}) {
    return null;
  }
}
