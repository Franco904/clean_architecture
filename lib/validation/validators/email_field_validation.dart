import '../../contracts/contracts.dart';

class EmailFieldValidation implements FieldValidation {
  @override
  final String field;

  EmailFieldValidation(this.field);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final exp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return exp.hasMatch(value) ? null : 'Email inválido';
  }
}
