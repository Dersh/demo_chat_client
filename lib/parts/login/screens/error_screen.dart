import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetryTapped;
  ErrorScreen({@required this.onRetryTapped}) : assert(onRetryTapped != null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Ошибка, проверьте подключение к интернету',
              style: TextStyle(color: Colors.red),
            ),
            RaisedButton(
              child: const Text('Еще раз'),
              onPressed: onRetryTapped,
            ),
          ],
        ),
      ),
    );
  }
}
