import 'dart:async';

import '../../contracts/contracts.dart';

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _validationController = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _validationController.stream.map((state) => state.emailError).distinct();
  Stream<String?> get passwordErrorStream => _validationController.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _validationController.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _validationController.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  void _update() => _validationController.add(_state);

  void validateEmail(String email) {
    _state.emailFieldValue = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.passwordFieldValue = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    await authentication.auth(AuthenticationParams(email: _state.emailFieldValue!, password: _state.passwordFieldValue!));

    _state.isLoading = false;
    _update();
  }
}

class LoginState {
  String? emailFieldValue;
  String? passwordFieldValue;

  String? emailError;
  String? passwordError;

  bool isLoading = false;

  bool get isFormValid {
    return (emailError == null && passwordError == null) && (emailFieldValue != null && passwordFieldValue != null);
  }
}
