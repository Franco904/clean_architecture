import '../../../../contracts/contracts.dart';
import '../../../../validation/validation.dart';

Validation makeLoginValidationComposite() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailFieldValidation('email'),
    RequiredFieldValidation('password'),
  ]);
}
