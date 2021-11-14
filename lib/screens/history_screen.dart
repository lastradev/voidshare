import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/history_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: FutureBuilder(
        future: Hive.openBox<HistoryEntry>('history'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Upload History',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Text('Nothing here yet...'),
                      ],
                    ),
                    Image.asset(
                      'assets/images/flat_characters.webp',
                      height: MediaQuery.of(context).size.height / 2.5,
                    ),
                  ],
                ),
              );
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.box<HistoryEntry>('history').close();
    super.dispose();
  }
}
