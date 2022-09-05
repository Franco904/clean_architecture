import '../../contracts/contracts.dart';

class EmailFieldValidation implements FieldValidation {
  @override
  final String field;

  EmailFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}