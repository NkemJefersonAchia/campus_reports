import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/priority_helpers.dart';

void main() {
  group('priorityLabel', () {
    test('returns correct label for each priority', () {
      expect(priorityLabel('urgent'), 'Urgent');
      expect(priorityLabel('high'), 'High Priority');
      expect(priorityLabel('normal'), 'Normal');
      expect(priorityLabel('low'), 'Low');
    });

    test('is case-insensitive', () {
      expect(priorityLabel('URGENT'), 'Urgent');
      expect(priorityLabel('High'), 'High Priority');
    });
  });
}
