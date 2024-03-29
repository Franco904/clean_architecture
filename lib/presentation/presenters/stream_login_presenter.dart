import 'dart:async';

import '../../contracts/contracts.dart';
import '../../domain/domain.dart';

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;

  StreamController<LoginState>? _validationController = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _validationController?.stream.map((state) => state.emailError).distinct() as Stream<String?>;
  Stream<String?> get passwordErrorStream => _validationController?.stream.map((state) => state.passwordError).distinct() as Stream<String?>;
  Stream<String?> get mainErrorStream => _validationController?.stream.map((state) => state.mainError).distinct() as Stream<String?>;
  Stream<bool> get isFormValidStream => _validationController?.stream.map((state) => state.isFormValid).distinct() as Stream<bool>;
  Stream<bool> get isLoadingStream => _validationController?.stream.map((state) => state.isLoading).distinct() as Stream<bool>;

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  void _update() => _validationController?.add(_state);

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

    try {
      await authentication.auth(AuthenticationParams(email: _state.emailFieldValue!, password: _state.passwordFieldValue!));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _update();
  }

  Future<void> dispose() async {
    _validationController?.close();
    _validationController = null;
  }
}

class LoginState {
  String? emailFieldValue;
  String? passwordFieldValue;

  String? emailError;
  String? passwordError;

  String? mainError;

  bool isLoading = false;

  bool get isFormValid {
    return (emailError == null && passwordError == null) && (emailFieldValue != null && passwordFieldValue != null);
  }
}
