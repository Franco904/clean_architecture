import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../contracts/contracts.dart';
import '../../utils/utils.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter, {Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Future<void> dispose() async {
    widget.presenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      body: Builder(builder: (_) {
        widget.presenter.isLoadingStream.listen((isLoading) async {
          if (isLoading) {
            showSpinnerDialog(context);
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });

        widget.presenter.mainErrorStream.listen((errorMessage) {
          if (errorMessage != null) {
            showErrorMessage(context, errorMessage);
          }
        });

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: ListView(
            children: <Widget>[
              const LoginHeader(),
              const Headline1(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        const EmailInput(),
                        const PasswordInput(),
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            const LoginButton(),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              key: const Key('criar_conta_button'),
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
