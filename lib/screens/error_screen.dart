import 'package:flutter/material.dart';

/// Error screen for unsuccessful upload.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);
  static const routeName = '/error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        /// True value needed to retry upload.
        onPressed: () => Navigator.of(context).pop(true),
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('TRY AGAIN'),
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Something went wrong!',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Text('Please, try again.'),
              ],
            ),
            Image.asset(
              'assets/images/robot.png',
              width: 350,
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
