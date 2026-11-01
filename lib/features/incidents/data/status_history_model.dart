import 'package:cloud_firestore/cloud_firestore.dart';

class StatusHistoryEntry {
  final String id;
  final String status;
  final String? note;
  final String changedBy;
  final String changedByName;
  final DateTime timestamp;

  const StatusHistoryEntry({
    required this.id,
    required this.status,
    this.note,
    required this.changedBy,
    required this.changedByName,
    required this.timestamp,
  });

  factory StatusHistoryEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StatusHistoryEntry(
      id: doc.id,
      status: data['status'] ?? '',
      note: data['note'],
      changedBy: data['changedBy'] ?? '',
      changedByName: data['changedByName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  bool get hasNote => note != null && note!.isNotEmpty;

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() =>
      'StatusHistoryEntry(status: $status, changedBy: $changedByName, timestamp: $timestamp)';

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'note': note,
      'changedBy': changedBy,
      'changedByName': changedByName,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
