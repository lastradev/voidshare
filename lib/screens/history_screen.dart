import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/history_entry.dart';
import '../widgets/history_list_view.dart';

/// Screen containing uploads history.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<HistoryEntry>('history');
    historyBox.deleteExpiredEntries();

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: historyBox.length > 0
          ? const HistoryListView()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const Text('Nothing here yet'),
                    ],
                  ),
                  Image.asset(
                    'assets/images/flat_characters.webp',
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                ],
              ),
            ),
    );
  }
}
