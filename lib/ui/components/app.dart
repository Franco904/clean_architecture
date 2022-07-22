import 'package:clean_architecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class CleanArchitectureApp extends StatelessWidget {
  const CleanArchitectureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
