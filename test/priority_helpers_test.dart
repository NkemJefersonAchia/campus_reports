import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/priority_helpers.dart';
import 'package:campus_reports/core/theme/app_colors.dart';

void main() {
  group('priorityColor', () {
    test('returns destructive for urgent', () {
      expect(priorityColor('urgent'), AppColors.destructive);
      expect(priorityColor('Urgent'), AppColors.destructive);
    });

    test('returns orange for high', () {
      expect(priorityColor('high'), Colors.orange);
    });

    test('returns blue for normal', () {
      expect(priorityColor('normal'), AppColors.statusInProgress);
    });

    test('returns green for low', () {
      expect(priorityColor('low'), AppColors.statusResolved);
    });

    test('returns grey for unknown', () {
      expect(priorityColor(''), AppColors.statusRejected);
    });
  });

  group('priorityLabel', () {
    test('returns correct labels', () {
      expect(priorityLabel('urgent'), 'Urgent');
      expect(priorityLabel('high'), 'High Priority');
      expect(priorityLabel('normal'), 'Normal');
      expect(priorityLabel('low'), 'Low Priority');
      expect(priorityLabel('banana'), 'Unknown');
    });
  });

  group('priorityIcon', () {
    test('returns distinct icons for each level', () {
      expect(priorityIcon('urgent'), Icons.error_rounded);
      expect(priorityIcon('high'), Icons.warning_amber_rounded);
      expect(priorityIcon('normal'), Icons.info_outline_rounded);
      expect(priorityIcon('low'), Icons.arrow_downward_rounded);
    });
  });
}
