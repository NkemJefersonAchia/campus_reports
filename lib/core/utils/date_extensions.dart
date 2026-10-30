import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String get shortDate => DateFormat('MMM d').format(this);
  String get fullDate => DateFormat('MMMM d, yyyy').format(this);
  String get timeOnly => DateFormat('h:mm a').format(this);
  String get dateTime => DateFormat('MMM d, h:mm a').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(startOfWeek.subtract(const Duration(days: 1)));
  }

  String get smartDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isThisWeek) return DateFormat('EEEE').format(this);
    return shortDate;
  }
}
