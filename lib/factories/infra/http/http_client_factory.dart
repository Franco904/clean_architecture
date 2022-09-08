import 'package:http/http.dart';

import '../../../contracts/contracts.dart';
import '../../../infra/infra.dart';

HttpAdapter makeHttpHandlerAdapter() {
  return HttpHandlerAdapter(Client());
}
