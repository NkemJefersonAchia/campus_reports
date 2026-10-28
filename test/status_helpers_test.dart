import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/status_helpers.dart';

void main() {
  group('statusDisplayName', () {
    test('returns correct display name for each status', () {
      expect(statusDisplayName('Submitted'), 'Submitted');
      expect(statusDisplayName('In Progress'), 'In Progress');
      expect(statusDisplayName('Resolved'), 'Resolved');
      expect(statusDisplayName('Rejected'), 'Rejected');
    });

    test('returns raw value for unknown status', () {
      expect(statusDisplayName('Unknown'), 'Unknown');
    });
  });
}
