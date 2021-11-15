import 'dart:math';

class Formatters {
  /// Returns bytes size converted to:
  /// B, KB, MB, GB, TB, PB, EB, ZB or YB 
  ///
  /// As written by zzpmaster.
  /// https://gist.github.com/zzpmaster/ec51afdbbfa5b2bf6ced13374ff891d9
  ///
  /// First parameter should be number of bytes, second parameter should be
  /// number of decimal positions you want returned.
  ///
  /// ```dart
  /// formatBytes(1536, 1) == '1.5 KB' 
  /// ```
  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    var i = (log(bytes) / log(1024)).floor();

    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
