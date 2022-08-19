import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black12,
    content: Text(
      errorMessage,
      textAlign: TextAlign.center,
    ),
  ));
}
