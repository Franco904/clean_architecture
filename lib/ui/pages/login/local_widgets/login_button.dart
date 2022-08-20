import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../contracts/contracts.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (_, snapshot) {
          return ElevatedButton(
            key: const Key('entrar_button'),
            onPressed: snapshot.data == null ? null : (snapshot.data! ? presenter.auth : null),
            child: const Text('Entrar'),
          );
        });
  }
}
