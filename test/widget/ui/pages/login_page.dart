import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/ui/pages/pages.dart';

void main() {
  // Testes mais complexos
  testWidgets('Deve carregar tela com estado inicial correto', (tester) async {
    const loginPage = MaterialApp(home: LoginPage());

    await tester.pumpWidget(loginPage);
    await tester.pumpAndSettle();

    final emailFieldChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(emailFieldChildren, findsOneWidget);
  });
}
