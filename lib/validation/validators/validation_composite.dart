import '../../contracts/contracts.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String? field, required String? value}) {
    String? error;

    final filteredValidationsByField = validations.where((validation) => validation.field == field);

    for (final validation in filteredValidationsByField) {
      error = validation.validate(value);

      if (error != null && error.isNotEmpty) {
        return error;
      }
    }

    return error;
  }
}
