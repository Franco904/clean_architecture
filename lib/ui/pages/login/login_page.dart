import 'package:clean_architecture/ui/pages/login/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter presenter;

  const LoginPage(this.presenter, {Key? key}) : super(key: key);

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
                    StreamBuilder<String>(
                      stream: presenter.emailErrorStream,
                      builder: (_, snapshot) {
                        return TextFormField(
                          key: const Key('Email'),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                            errorText: snapshot.data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter.validateEmail,
                        );
                      }
                    ),
                    TextFormField(
                      key: const Key('Senha'),
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.password),
                      ),
                      obscureText: true,
                      onChanged: presenter.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        const ElevatedButton(
                          onPressed: null,
                          child: Text('Entrar'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: null,
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
