import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class MockLoginPresenter extends Mock implements ILoginPresenter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage Tests | ', () {
    late MockLoginPresenter mockPresenter;
    late StreamController<String> emailErrorController;

    Future<void> loadLoginPage(WidgetTester tester) async {
      mockPresenter = MockLoginPresenter();

      emailErrorController = StreamController<String>();
      when(mockPresenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

      final page = MaterialApp(home: LoginPage(mockPresenter));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
    }

    tearDown(() {
      emailErrorController.close();

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

      final loginButton = tester.firstWidget<ElevatedButton>(find.byType(ElevatedButton));

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
    });

    testWidgets('Deve chamar validação de email com valores corretos', (tester) async {
      await loadLoginPage(tester);

      final emailFieldChildren = find.byKey(const Key('Email'));
      final passwordFieldChildren = find.byKey(const Key('Senha'));

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
  });
}
