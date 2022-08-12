import 'package:clean_architecture/ui/core/app_theme.dart';
import 'package:clean_architecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class CleanArchitectureApp extends StatelessWidget {
  const CleanArchitectureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture',
      theme: getAppTheme(),
      home: LoginPage(null as ILoginPresenter),
    );
  }
}
