import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ilogin_presenter.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

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
