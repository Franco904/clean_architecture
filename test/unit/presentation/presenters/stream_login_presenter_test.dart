import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';
import 'package:clean_architecture/presentation/presentation.dart';

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

    test('Deve notificar a stream emailErrorStream caso o Validation retorne mensagem de erro', () {
      mockErrorMessage('erro');

      // Tem de ser antes do action porque o resultado da emissão demora a ocorrer
      expectLater(sut.emailErrorStream, emits('erro'));

      sut.validateEmail(email);
    });

    test('Deve notificar apenas uma vez a stream emailErrorStream caso o Validation retorne mensagem de erro', () {
      mockErrorMessage('erro');

      sut.emailErrorStream.listen(expectAsync1((errorMessage) => expect(errorMessage, 'erro')));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });
}
