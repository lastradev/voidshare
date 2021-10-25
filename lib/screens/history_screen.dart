import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.lightBlue,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('History', style: Theme.of(context).textTheme.headline4),
                const Text('Nothing here yet'),
              ],
            ),
            const Image(
              image:
                  AssetImage('assets/images/flat_characters_illustration.png'),
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
