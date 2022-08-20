import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockValidation extends Mock implements Validation {}

void main() {
  group('StreamLoginPresenter | ', () {
    late StreamLoginPresenter sut;
    late MockValidation mockValidation;
    late String email;

    PostExpectation whenValidationCalled({String? field}) => when(mockValidation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ));

    void mockErrorMessage(String errorMessage, {String? field}) => whenValidationCalled().thenReturn(errorMessage);

    setUp(() {
      mockValidation = MockValidation();
      sut = StreamLoginPresenter(validation: mockValidation);
      email = faker.internet.email();
    });

    tearDown(() {
      reset(mockValidation);
      resetMockitoState();
    });

    test('Deve chamar Validation com email correto', () {
      sut.validateEmail(email);

      verify(mockValidation.validate(field: 'email', value: email)).called(1);
    });

    test('Deve notificar a stream emailErrorStream caso o Validation retornar mensagem de erro', () {
      mockErrorMessage('erro');

      // Tem de ser antes do action porque o resultado da emissão demora a ocorrer
      expectLater(sut.emailErrorStream, emits('erro'));

      sut.validateEmail(email);
    });
  });
}

class StreamLoginPresenter {
  final Validation validation;

  final _validationController = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _validationController.stream.map((state) => state.emailError);

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _validationController.add(_state);
  }
}

class LoginState {
  String emailError;

  LoginState({
    this.emailError = '',
  });
}
