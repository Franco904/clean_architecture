import '../../../ui/ui.dart';
import '../../presentation/presentation.dart';

LoginPage makeLoginPage() {
  return LoginPage(makeStreamLoginPresenter());
}
