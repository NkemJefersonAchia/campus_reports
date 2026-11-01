import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/incidents/data/incident_model.dart';

void main() {
  IncidentModel _make({
    String status = 'Submitted',
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return IncidentModel(
      id: 'test-1',
      title: 'Broken pipe',
      description: 'Water leaking in Block A corridor',
      category: 'Water',
      location: 'Block A',
      status: status,
      reporterId: 'user-1',
      reporterName: 'Test User',
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      resolvedAt: resolvedAt,
    );
  }

  group('IncidentModel', () {
    test('toJson returns same map as toMap', () {
      final incident = _make();
      expect(incident.toJson(), equals(incident.toMap()));
    });

    test('toString includes id, title, and status', () {
      final incident = _make();
      final str = incident.toString();
      expect(str, contains('test-1'));
      expect(str, contains('Broken pipe'));
      expect(str, contains('Submitted'));
    });

    test('resolutionTime returns null when not resolved', () {
      final incident = _make(status: 'In Progress');
      expect(incident.resolutionTime, isNull);
    });

    test('resolutionTime returns duration when resolved', () {
      final created = DateTime(2026, 10, 1, 10, 0);
      final resolved = DateTime(2026, 10, 3, 10, 0);
      final incident = _make(
        status: 'Resolved',
        createdAt: created,
        resolvedAt: resolved,
      );
      expect(incident.resolutionTime, equals(const Duration(days: 2)));
    });

    test('isOverdue true when open and older than 7 days', () {
      final old = DateTime.now().subtract(const Duration(days: 10));
      final incident = _make(status: 'Submitted', createdAt: old);
      expect(incident.isOverdue, isTrue);
    });

    test('isOverdue false when resolved', () {
      final old = DateTime.now().subtract(const Duration(days: 10));
      final incident = _make(
        status: 'Resolved',
        createdAt: old,
        resolvedAt: DateTime.now(),
      );
      expect(incident.isOverdue, isFalse);
    });

    test('isOverdue false when recent', () {
      final recent = DateTime.now().subtract(const Duration(days: 2));
      final incident = _make(status: 'Submitted', createdAt: recent);
      expect(incident.isOverdue, isFalse);
    });

    test('copyWith preserves unchanged fields', () {
      final incident = _make();
      final updated = incident.copyWith(status: 'In Progress');
      expect(updated.status, 'In Progress');
      expect(updated.title, incident.title);
      expect(updated.category, incident.category);
    });
  });
}
