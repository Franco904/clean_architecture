import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../contracts/contracts.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
        stream: presenter.passwordErrorStream,
        builder: (_, snapshot) {
          return TextFormField(
            key: const Key('password_field'),
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(Icons.password, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data == null ? null : (snapshot.data!.isEmpty ? null : snapshot.data),
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
