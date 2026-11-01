import 'incident_model.dart';

class ReportStats {
  final int total;
  final int submitted;
  final int inProgress;
  final int resolved;
  final int rejected;

  const ReportStats({
    this.total = 0,
    this.submitted = 0,
    this.inProgress = 0,
    this.resolved = 0,
    this.rejected = 0,
  });

  double get resolutionRate =>
      total > 0 ? (resolved / total) * 100 : 0;

  int get open => submitted + inProgress;

  factory ReportStats.fromIncidents(List<Map<String, dynamic>> incidents) {
    int submitted = 0, inProgress = 0, resolved = 0, rejected = 0;
    for (final i in incidents) {
      switch (i['status'] as String?) {
        case 'Submitted':
          submitted++;
        case 'In Progress':
          inProgress++;
        case 'Resolved':
          resolved++;
        case 'Rejected':
          rejected++;
      }
    }
    return ReportStats(
      total: incidents.length,
      submitted: submitted,
      inProgress: inProgress,
      resolved: resolved,
      rejected: rejected,
    );
  }

  factory ReportStats.fromModels(List<IncidentModel> incidents) {
    int submitted = 0, inProgress = 0, resolved = 0, rejected = 0;
    for (final i in incidents) {
      switch (i.status) {
        case 'Submitted':
          submitted++;
        case 'In Progress':
          inProgress++;
        case 'Resolved':
          resolved++;
        case 'Rejected':
          rejected++;
      }
    }
    return ReportStats(
      total: incidents.length,
      submitted: submitted,
      inProgress: inProgress,
      resolved: resolved,
      rejected: rejected,
    );
  }
}
