import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/formatters.dart';

import '../models/history_entry.dart';
import 'custom_snack_bars.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<HistoryEntry>('history');
    final historyLength = historyBox.length;

    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: historyLength,
            itemBuilder: (context, index) {
              /// Newest file on top.
              final reversedOrderIndex = historyLength - index - 1;
              final entry =
                  historyBox.getAt(reversedOrderIndex) as HistoryEntry;

              return Card(
                elevation: 3,
                shadowColor: Colors.grey.shade50.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: ListTile(
                  onLongPress: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    CustomSnackBars.showCustomSnackBar(
                      context,
                      'File expires in ${entry.retention} days.',
                      action: SnackBarAction(
                        label: 'MORE INFO',
                        onPressed: () => launch('https://voidshare.xyz/'),
                      ),
                    );
                  },
                  leading: Image.asset('assets/images/folder.png', width: 50),
                  title: Text(
                    entry.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${Formatters.formatBytes(entry.size, 1)} - ${DateFormat('dd/MMM/yyyy').format(entry.uploadDate)}',
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  trailing: IconButton(
                    tooltip: 'Share',
                    onPressed: () => Share.share(entry.url),
                    icon: const Icon(Icons.share_rounded),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
