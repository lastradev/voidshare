import 'dart:math';

import 'package:hive/hive.dart';

part 'history_entry.g.dart';

// Note: If changing this file, see readme for how to regenerate
// HistoryEntryAdapter class.

/// Model class for Hive's history box, holds information about uploads.
@HiveType(typeId: 0)
class HistoryEntry {
  HistoryEntry({
    required this.name,
    required this.size,
    required this.url,
    required this.uploadDate,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final int size;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final DateTime uploadDate;

  /// The number of days for the file to expire on the server.
  ///
  /// Measures obtained from https://0x0.st.
  int get retention {
    final daysSinceUpload = DateTime.now().difference(uploadDate).inDays;

    const minimumFileRetention = 30;
    const maximumFileRetention = 365;
    const maxFileSize = 536870912;

    /// As described in https://0x0.st.
    final daysToExpire =
        (minimumFileRetention + (minimumFileRetention - maximumFileRetention) * pow(size / maxFileSize - 1, 3)).floor();

    final result = daysToExpire - daysSinceUpload;
    return result;
  }
}