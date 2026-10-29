import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/incidents/data/incident_filter.dart';

void main() {
  group('IncidentFilter', () {
    test('hasActiveFilters returns false when empty', () { expect(const IncidentFilter().hasActiveFilters, isFalse); });
    test('hasActiveFilters returns true with status', () { expect(const IncidentFilter(status: 'Submitted').hasActiveFilters, isTrue); });
    test('copyWith preserves unchanged fields', () {
      final updated = const IncidentFilter(status: 'Submitted', category: 'Water').copyWith(status: 'Resolved');
      expect(updated.status, 'Resolved'); expect(updated.category, 'Water');
    });
    test('clearFilters resets but keeps showOnlyMine', () {
      final cleared = const IncidentFilter(status: 'Submitted', category: 'Water', showOnlyMine: true).clearFilters();
      expect(cleared.status, isNull); expect(cleared.showOnlyMine, isTrue);
    });
  });
}
