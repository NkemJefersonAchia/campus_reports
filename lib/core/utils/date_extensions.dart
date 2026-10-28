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
}
