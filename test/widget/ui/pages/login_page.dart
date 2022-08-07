import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/ui/pages/pages.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Testes mais complexos
  testWidgets('Deve carregar tela com estado inicial correto', (tester) async {
    const loginPage = MaterialApp(home: LoginPage());

    await tester.pumpWidget(loginPage);
    await tester.pumpAndSettle();

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
}
