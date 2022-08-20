import 'package:flutter/material.dart';

import '../../contracts/contracts.dart';
import '../core/core.dart';
import '../pages/pages.dart';

class CleanArchitectureApp extends StatelessWidget {
  const CleanArchitectureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture',
      theme: getAppTheme(),
      home: LoginPage(null as LoginPresenter),
    );
  }
}
