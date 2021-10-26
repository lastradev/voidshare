import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
        ),
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
            Image(
              image: const AssetImage(
                'assets/images/flat_characters_illustration.png',
              ),
              height: MediaQuery.of(context).size.height / 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
