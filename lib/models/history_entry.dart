import 'package:hive/hive.dart';

part 'history_entry.g.dart';

@HiveType(typeId: 0)
class HistoryEntry {
  HistoryEntry({
    required this.name,
    required this.size,
    required this.url,
    required this.uploadDate,
    required this.expirationDate,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final double size;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final DateTime uploadDate;
  @HiveField(4)
  final DateTime expirationDate;
}
