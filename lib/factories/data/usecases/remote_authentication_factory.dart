import '../../../contracts/contracts.dart';
import '../../../data/data.dart';
import '../../infra/infra.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpAdapter: makeHttpHandlerAdapter(),
    url: makeApiUrl('login'),
  );
}
