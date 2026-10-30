import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/date_extensions.dart';

void main() {
  group('isToday', () {
    test('returns true for today', () {
      expect(DateTime.now().isToday, isTrue);
    });
    test('returns false for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isToday, isFalse);
    });
  });

  group('isYesterday', () {
    test('returns true for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);
    });
    test('returns false for today', () {
      expect(DateTime.now().isYesterday, isFalse);
    });
  });

  group('smartDate', () {
    test('returns Today for today', () {
      expect(DateTime.now().smartDate, 'Today');
    });
    test('returns Yesterday for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.smartDate, 'Yesterday');
    });
  });

  group('formatting', () {
    test('shortDate formats correctly', () {
      final date = DateTime(2026, 10, 30);
      expect(date.shortDate, 'Oct 30');
    });
    test('fullDate formats correctly', () {
      final date = DateTime(2026, 10, 30);
      expect(date.fullDate, 'October 30, 2026');
    });
  });
}
