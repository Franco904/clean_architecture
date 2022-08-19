import 'package:flutter/material.dart';

Future<void> showSpinnerDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => SimpleDialog(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              'Aguarde ...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}
