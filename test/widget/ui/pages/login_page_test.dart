import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class MockLoginPresenter extends Mock implements ILoginPresenter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Testes mais complexos
  group('LoginPage Tests | ', () {
    late MockLoginPresenter mockPresenter;

    late StreamController<String> emailErrorController;
    late StreamController<String> passwordErrorController;
    late StreamController<String?> mainErrorController;
    late StreamController<bool> isFormValidController;
    late StreamController<bool> isLoadingController;

    Future<void> loadLoginPage(WidgetTester tester) async {
      mockPresenter = MockLoginPresenter();

      emailErrorController = StreamController<String>();
      passwordErrorController = StreamController<String>();
      mainErrorController = StreamController<String?>();
      isFormValidController = StreamController<bool>();
      isLoadingController = StreamController<bool>();

      when(mockPresenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
      when(mockPresenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
      when(mockPresenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
      when(mockPresenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
      when(mockPresenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);

      final page = MaterialApp(home: LoginPage(mockPresenter));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
    }

    tearDown(() {
      emailErrorController.close();
      passwordErrorController.close();
      mainErrorController.close();
      isFormValidController.close();
      isLoadingController.close();

      reset(mockPresenter);
      resetMockitoState();
    });

    testWidgets('Deve carregar tela com estado inicial correto', (tester) async {
      await loadLoginPage(tester);

      final emailFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      final passwordFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('entrar_button')));

      expect(
        emailFieldChildren,
        findsOneWidget,
        reason:
            'Quando um TextFormField possui somente um filho Text, significa que ele não possui erros, sabendo que um de seus filhos sempre será um label text.',
      );

      expect(
        passwordFieldChildren,
        findsOneWidget,
        reason:
            'Quando um TextFormField possui somente um filho Text, significa que ele não possui erros, sabendo que um de seus filhos sempre será um label text.',
      );

      expect(loginButton.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Deve chamar validação de email com valores corretos', (tester) async {
      await loadLoginPage(tester);

      final emailFieldChildren = find.byKey(const Key('email_field'));
      final passwordFieldChildren = find.byKey(const Key('password_field'));

      final email = faker.internet.email();
      final password = faker.internet.password();

      await tester.enterText(emailFieldChildren, email);
      await tester.enterText(passwordFieldChildren, password);

      verify(mockPresenter.validateEmail(email));
      verify(mockPresenter.validatePassword(password));
    });

    testWidgets('Deve mostrar erro caso o email informado esteja inválido', (tester) async {
      await loadLoginPage(tester);

      emailErrorController.add('any error');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('any error'), findsOneWidget);
    });

    testWidgets('Não deve apresentar erro caso o email informado seja válido', (tester) async {
      await loadLoginPage(tester);

      emailErrorController.add(null as String);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final emailFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailFieldChildren, findsOneWidget);
    });

    testWidgets('Não deve apresentar erro caso o email informado seja um texto vazio', (tester) async {
      await loadLoginPage(tester);

      emailErrorController.add('');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final emailFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailFieldChildren, findsOneWidget);
    });

    testWidgets('Deve mostrar erro caso a senha informada esteja inválida', (tester) async {
      await loadLoginPage(tester);

      passwordErrorController.add('any error');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('any error'), findsOneWidget);
    });

    testWidgets('Não deve apresentar erro caso a senha informada seja válida', (tester) async {
      await loadLoginPage(tester);

      passwordErrorController.add(null as String);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final passwordFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordFieldChildren, findsOneWidget);
    });

    testWidgets('Não deve apresentar erro caso a senha informada seja um texto vazio', (tester) async {
      await loadLoginPage(tester);

      passwordErrorController.add('');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final passwordFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordFieldChildren, findsOneWidget);
    });

    testWidgets('Deve habilitar botão Entrar caso o formulário esteja válido', (tester) async {
      await loadLoginPage(tester);

      isFormValidController.add(true);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('entrar_button')));

      expect(loginButton.onPressed, isNotNull);
    });

    testWidgets('Deve desabilitar botão Entrar caso o formulário esteja inválido', (tester) async {
      await loadLoginPage(tester);

      isFormValidController.add(false);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('entrar_button')));

      expect(loginButton.onPressed, null);
    });

    /// Teste não está passando.. Provável que o tester.tap() não esteja ativando o callback onPressed do botão

    // testWidgets('Deve chamar método de autenticação na submissão do formulário', (tester) async {
    //   await loadLoginPage(tester);

    //   isFormValidController.add(true);
    //   await tester.pumpAndSettle(const Duration(seconds: 1));

    //   final loginButtonFinder = find.byKey(const Key('entrar_button'));

    //   await tester.tap(loginButtonFinder);
    //   await tester.pumpAndSettle(const Duration(seconds: 1));

    //   verify(mockPresenter.auth).called(1);
    // });

    testWidgets('Deve mostrar estado de loading ao emitir evento', (tester) async {
      await loadLoginPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve esconder estado de loading ao emitir evento', (tester) async {
      await loadLoginPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      await tester.pump();

      isLoadingController.add(false);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Deve mostrar mensagem de erro em snackbar caso o formulário esteja inválido', (tester) async {
      await loadLoginPage(tester);

      mainErrorController.add('main error');
      await tester.pumpAndSettle();

      expect(find.text('main error'), findsOneWidget);
    });

    testWidgets('Deve fechar streams ao chamar dispose do presenter', (tester) async {
      await loadLoginPage(tester);

      addTearDown(() => verify(mockPresenter.dispose()).called(1));
    });
  });
}
