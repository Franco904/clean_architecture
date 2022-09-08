import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../contracts/contracts.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
        stream: presenter.emailErrorStream,
        builder: (_, snapshot) {
          return TextFormField(
            key: const Key('email_field'),
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data == null ? null : (snapshot.data!.isEmpty ? null : snapshot.data),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
