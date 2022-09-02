import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockValidation extends Mock implements Validation {}

class MockAuthentication extends Mock implements Authentication {}

void main() {
  group('RequiredFieldValidation | ', () {
    late RequiredFieldValidation sut;

    // PostExpectation whenValidationCalled({String? field}) => when(mockValidation.validate(
    //       field: field ?? anyNamed('field'),
    //       value: anyNamed('value'),
    //     ));

    // PostExpectation whenAuthenticationCalled() => when(mockAuthentication.auth(any as AuthenticationParams));

    // void mockValidationErrorMessage(String errorMessage, {String? field}) => whenValidationCalled(field: field).thenReturn(errorMessage);

    // void mockAuthenticationResult() => whenAuthenticationCalled().thenAnswer((_) async => Account(token: faker.guid.guid()));

    // void mockAuthenticationError(DomainError domainError) => whenAuthenticationCalled().thenThrow(domainError);

    setUp(() {});

    tearDown(() {
      // reset(mockValidation);
      // reset(mockAuthentication);

      resetMockitoState();
    });

    test('Deve retornar nulo se o valor passado não estiver vazio', () {
      sut = RequiredFieldValidation('any_field');

      final error = sut.validate('any_value');

      expect(error, null);
    });

    test('Deve retornar mensagem de erro se o valor passado estiver vazio', () {
      sut = RequiredFieldValidation('any_field');

      final error = sut.validate('');

      expect(error, 'Campo Obrigatório');
    });
  });
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return value.isEmpty ? 'Campo Obrigatório' : null;
  }
}

abstract class FieldValidation {
  String get field;

  String? validate(String value);
}
