import 'dart:math';

import 'package:hive/hive.dart';

part 'history_entry.g.dart';

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

  int getFileRetention() {
    final daysSinceUpload = DateTime.now().difference(uploadDate).inDays;

    const minAge = 30;
    const maxAge = 365;
    const maxSize = 536870912;

    final originalRetention =
        (minAge + (minAge - maxAge) * pow(size / maxSize - 1, 3)).floor();

    final result = originalRetention - daysSinceUpload;
    return result;
  }
}
