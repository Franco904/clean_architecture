import 'dart:async';

import '../../contracts/contracts.dart';

class StreamLoginPresenter {
  final Validation validation;

  final _validationController = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _validationController.stream.map((state) => state.emailError).distinct();

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _validationController.add(_state);
  }
}

class LoginState {
  String emailError;

  LoginState({
    this.emailError = '',
  });
}