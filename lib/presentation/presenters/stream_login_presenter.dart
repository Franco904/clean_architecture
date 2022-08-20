import 'dart:async';

import '../../contracts/contracts.dart';

class StreamLoginPresenter {
  final Validation validation;

  final _validationController = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _validationController.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _validationController.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _validationController.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

  void _update() => _validationController.add(_state);

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }
}

class LoginState {
  String emailError;
  String passwordError;
  bool get isFormValid => false;

  LoginState({
    this.emailError = '',
    this.passwordError = '',
  });
}
