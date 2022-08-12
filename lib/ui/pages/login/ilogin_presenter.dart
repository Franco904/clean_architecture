abstract class ILoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;

  void validateEmail(String email);

  void validatePassword(String email);
}
