import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
