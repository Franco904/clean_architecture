import 'package:flutter/material.dart';

import 'local_widgets/local_widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: ListView(
          children: <Widget>[
            const LoginHeader(),
            const Headline1(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Senha', icon: Icon(Icons.password)),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person),
                          label: const Text('Criar conta'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
