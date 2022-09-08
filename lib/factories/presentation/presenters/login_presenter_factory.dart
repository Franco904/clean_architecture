import '../../../contracts/contracts.dart';
import '../../../presentation/presentation.dart';
import '../../data/data.dart';
import '../../validation/validation.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeLoginValidationComposite(),
    authentication: makeRemoteAuthentication(),
  );
}
