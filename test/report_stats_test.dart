import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/incidents/data/incident_model.dart';
import 'package:campus_reports/features/incidents/data/report_stats.dart';

void main() {
  group('ReportStats', () {
    test('defaults are zero', () {
      const s = ReportStats();
      expect(s.total, 0);
      expect(s.submitted, 0);
    });

    test('fromIncidents counts correctly', () {
      final stats = ReportStats.fromIncidents([
        {'status': 'Submitted'},
        {'status': 'Submitted'},
        {'status': 'In Progress'},
        {'status': 'Resolved'},
      ]);
      expect(stats.total, 4);
      expect(stats.submitted, 2);
      expect(stats.inProgress, 1);
      expect(stats.resolved, 1);
      expect(stats.rejected, 0);
    });

    test('fromModels counts each status correctly', () {
      final models = [
        _makeIncident(status: 'Submitted'),
        _makeIncident(status: 'Submitted'),
        _makeIncident(status: 'In Progress'),
        _makeIncident(status: 'Resolved'),
        _makeIncident(status: 'Resolved'),
        _makeIncident(status: 'Resolved'),
        _makeIncident(status: 'Rejected'),
      ];
      final stats = ReportStats.fromModels(models);
      expect(stats.total, 7);
      expect(stats.submitted, 2);
      expect(stats.inProgress, 1);
      expect(stats.resolved, 3);
      expect(stats.rejected, 1);
    });

    test('open returns sum of submitted and inProgress', () {
      const stats = ReportStats(submitted: 4, inProgress: 2, resolved: 1);
      expect(stats.open, 6);
    });

    test('resolutionRate calculates percentage', () {
      const stats = ReportStats(total: 10, resolved: 3);
      expect(stats.resolutionRate, 30.0);
    });

    test('resolutionRate returns 0 when total is 0', () {
      const stats = ReportStats();
      expect(stats.resolutionRate, 0);
    });

    test('fromModels handles empty list', () {
      final stats = ReportStats.fromModels([]);
      expect(stats.total, 0);
      expect(stats.open, 0);
      expect(stats.resolutionRate, 0);
    });
  });
}

IncidentModel _makeIncident({required String status}) {
  return IncidentModel(
    id: 'test-${DateTime.now().microsecondsSinceEpoch}',
    title: 'Test incident',
    description: 'A test incident for unit testing',
    category: 'Facilities',
    location: 'Main Campus',
    locationDetail: 'Block A, Room 101',
    priority: 'normal',
    status: status,
    reporterId: 'user-1',
    reporterName: 'Test User',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
