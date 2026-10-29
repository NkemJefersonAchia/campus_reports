import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/incidents/data/report_stats.dart';

void main() {
  group('ReportStats', () {
    test('defaults are zero', () { const s = ReportStats(); expect(s.total, 0); expect(s.submitted, 0); });
    test('fromIncidents counts correctly', () {
      final stats = ReportStats.fromIncidents([{'status':'Submitted'},{'status':'Submitted'},{'status':'In Progress'},{'status':'Resolved'}]);
      expect(stats.total, 4); expect(stats.submitted, 2); expect(stats.inProgress, 1); expect(stats.resolved, 1); expect(stats.rejected, 0);
    });
  });
}
