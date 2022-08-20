import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockValidation extends Mock implements Validation {}

void main() {
  group('StreamLoginPresenter | ', () {
    late final StreamLoginPresenter sut;
    late final MockValidation mockValidation;

    test('Deve chamar Validation com email correto', () {
      mockValidation = MockValidation();
      sut = StreamLoginPresenter(validation: mockValidation);
      final email = faker.internet.email();

      sut.validateEmail(email);

      verify(mockValidation.validate(field: 'email', value: email)).called(1);
    });
  });
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}
