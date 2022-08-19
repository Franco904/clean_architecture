import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/global_widgets/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const CleanArchitectureApp());
}
