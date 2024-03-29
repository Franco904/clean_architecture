import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/contracts/contracts.dart';
import 'package:clean_architecture/domain/domain.dart';
import 'package:clean_architecture/presentation/presentation.dart';

class MockValidation extends Mock implements Validation {}

class MockAuthentication extends Mock implements Authentication {}

void main() {
  group('StreamLoginPresenter | ', () {
    late StreamLoginPresenter sut;

    late MockValidation mockValidation;
    late MockAuthentication mockAuthentication;

    late String email;
    late String password;

    PostExpectation whenValidationCalled({String? field}) => when(mockValidation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ));

    PostExpectation whenAuthenticationCalled() => when(mockAuthentication.auth(any as AuthenticationParams));

    void mockValidationErrorMessage(String errorMessage, {String? field}) => whenValidationCalled(field: field).thenReturn(errorMessage);

    void mockAuthenticationResult() => whenAuthenticationCalled().thenAnswer((_) async => Account(token: faker.guid.guid()));

    void mockAuthenticationError(DomainError domainError) => whenAuthenticationCalled().thenThrow(domainError);

    setUp(() {
      mockValidation = MockValidation();
      mockAuthentication = MockAuthentication();

      sut = StreamLoginPresenter(
        validation: mockValidation,
        authentication: mockAuthentication,
      );

      email = faker.internet.email();
      password = faker.internet.password();

      mockAuthenticationResult();
    });

    tearDown(() {
      reset(mockValidation);
      reset(mockAuthentication);

      resetMockitoState();
    });

    test('Deve chamar Validation com email correto', () {
      sut.validateEmail(email);

      verify(mockValidation.validate(field: 'email', value: email)).called(1);
    });

    test('Deve notificar a stream emailErrorStream caso o Validation retorne mensagem de erro', () {
      mockValidationErrorMessage('erro');

      // Tem de ser antes do action porque o resultado da emissão demora a ocorrer
      expectLater(sut.emailErrorStream, emits('erro'));

      sut.validateEmail(email);
    });

    test('Deve notificar streams emailErrorStream e isFormValidStream apenas uma vez caso o Validation retorne mensagem de erro', () {
      mockValidationErrorMessage('erro');

      sut.emailErrorStream.listen(expectAsync1((errorMessage) => expect(errorMessage, 'erro')));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Deve notificar streams emailErrorStream e isFormValidStream apenas uma vez caso o Validation retorne nulo', () {
      sut.emailErrorStream.listen(expectAsync1((errorMessage) => expect(errorMessage, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Deve chamar Validation com senha correta', () {
      sut.validatePassword(password);

      verify(mockValidation.validate(field: 'password', value: password)).called(1);
    });

    test('Deve notificar streams passwordErrorStream e isFormValidStream apenas uma vez caso o Validation retorne mensagem de erro', () {
      mockValidationErrorMessage('erro');

      sut.passwordErrorStream.listen(expectAsync1((errorMessage) => expect(errorMessage, 'erro')));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Deve notificar streams passwordErrorStream e isFormValidStream apenas uma vez caso o Validation retorne nulo', () {
      sut.passwordErrorStream.listen(expectAsync1((errorMessage) => expect(errorMessage, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Deve notificar streams emailErrorStream com mensagem de erro e passwordErrorStream ao combinar emissões', () {
      mockValidationErrorMessage('erroEmail', field: 'email');

      sut.emailErrorStream.listen(expectAsync1((errorEmail) => expect(errorEmail, 'erroEmail')));
      sut.passwordErrorStream.listen(expectAsync1((errorPassword) => expect(errorPassword, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('Deve notificar stream isFormValidStream com valor verdadeiro caso o Validation retornar nulo para os campos', () async {
      sut.emailErrorStream.listen(expectAsync1((errorEmail) => expect(errorEmail, null)));
      sut.passwordErrorStream.listen(expectAsync1((errorPassword) => expect(errorPassword, null)));

      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    });

    test('Deve chamar Authentication com os parâmetros corretos', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(mockAuthentication.auth(AuthenticationParams(email: email, password: password))).called(1);
    });

    test('Deve emitir eventos corretos caso o Authentication seja bem sucedido', () async {
      // mockAuthenticationResult() no setUp()

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    });

    test('Deve emitir eventos corretos caso o Authentication retorne um erro InvalidCredentialsError', () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([false]));

      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

      await sut.auth();
    });

    test('Deve emitir eventos corretos caso o Authentication retorne um erro UnexpectedError', () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([false]));

      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo de errado aconteceu. Tente novamente em breve.')));

      await sut.auth();
    });

    test('Deve fechar todas as streams abertas após executar o dispose', () async {
      // Emite nulo caso não haja erro, então não deve emitir após streams serem fechadas
      expectLater(sut.emailErrorStream, neverEmits(null));
      expectLater(sut.passwordErrorStream, neverEmits(null));

      await sut.dispose();

      sut.validateEmail(email);
      sut.validatePassword(password);
    });
  });
}
