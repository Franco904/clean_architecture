import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';

class MockValidation extends Mock implements Validation {}

void main() {
  group('StreamLoginPresenter | ', () {
    late final StreamLoginPresenter sut;
    late final MockValidation mockValidation;
    late String email;

    setUp(() {
      mockValidation = MockValidation();
      sut = StreamLoginPresenter(validation: mockValidation);
      email = faker.internet.email();
    });

    test('Deve chamar Validation com email correto', () {
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
