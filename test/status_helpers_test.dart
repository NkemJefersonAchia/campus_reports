import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/status_helpers.dart';
import 'package:campus_reports/core/theme/app_colors.dart';

void main() {
  group('statusDisplayName', () {
    test('returns formatted name for known statuses', () {
      expect(statusDisplayName('Submitted'), 'Submitted');
      expect(statusDisplayName('In Progress'), 'In Progress');
      expect(statusDisplayName('Resolved'), 'Resolved');
      expect(statusDisplayName('Rejected'), 'Rejected');
    });

    test('returns raw value for unknown status', () {
      expect(statusDisplayName('Custom'), 'Custom');
    });
  });

  group('statusColor', () {
    test('maps to named AppColors constants', () {
      expect(statusColor('Submitted'), AppColors.statusSubmitted);
      expect(statusColor('In Progress'), AppColors.statusInProgress);
      expect(statusColor('Resolved'), AppColors.statusResolved);
      expect(statusColor('Rejected'), AppColors.statusRejected);
    });
  });

  group('statusIcon', () {
    test('returns distinct icons for each status', () {
      expect(statusIcon('Submitted'), Icons.schedule_rounded);
      expect(statusIcon('In Progress'), Icons.autorenew_rounded);
      expect(statusIcon('Resolved'), Icons.check_circle_outline_rounded);
      expect(statusIcon('Rejected'), Icons.cancel_outlined);
    });
  });
}
