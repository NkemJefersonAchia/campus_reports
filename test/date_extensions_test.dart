import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/date_extensions.dart';

void main() {
  group('DateTimeFormatting', () {
    test('isToday returns true for today', () {
      expect(DateTime.now().isToday, isTrue);
    });

    test('isToday returns false for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isToday, isFalse);
    });

    test('fullDate formats correctly', () {
      final date = DateTime(2026, 10, 28);
      expect(date.fullDate, 'October 28, 2026');
    });
  });
}
