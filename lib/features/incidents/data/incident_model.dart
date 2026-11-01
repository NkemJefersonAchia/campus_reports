import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String? locationDetail;
  final String? photoUrl;
  final String priority; // 'normal' | 'urgent'
  final bool isAnonymous;
  final String status; // 'Submitted' | 'In Progress' | 'Resolved' | 'Rejected'
  final String reporterId;
  final String reporterName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final String? assignedTo;

  const IncidentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.locationDetail,
    this.photoUrl,
    this.priority = 'normal',
    this.isAnonymous = false,
    required this.status,
    required this.reporterId,
    required this.reporterName,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.assignedTo,
  });

  factory IncidentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IncidentModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      locationDetail: data['locationDetail'],
      photoUrl: data['photoUrl'],
      priority: data['priority'] ?? 'normal',
      isAnonymous: data['isAnonymous'] ?? false,
      status: data['status'] ?? 'Submitted',
      reporterId: data['reporterId'] ?? '',
      reporterName: data['reporterName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      assignedTo: data['assignedTo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'locationDetail': locationDetail,
      'photoUrl': photoUrl,
      'priority': priority,
      'isAnonymous': isAnonymous,
      'status': status,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'assignedTo': assignedTo,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  Duration? get resolutionTime {
    if (resolvedAt == null) return null;
    return resolvedAt!.difference(createdAt);
  }

  bool get isOverdue =>
      status != 'Resolved' &&
      status != 'Rejected' &&
      DateTime.now().difference(createdAt).inDays > 7;

  @override
  String toString() => 'IncidentModel(id: $id, title: $title, status: $status)';

  IncidentModel copyWith({
    String? status,
    String? assignedTo,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) {
    return IncidentModel(
      id: id,
      title: title,
      description: description,
      category: category,
      location: location,
      locationDetail: locationDetail,
      photoUrl: photoUrl,
      priority: priority,
      isAnonymous: isAnonymous,
      status: status ?? this.status,
      reporterId: reporterId,
      reporterName: reporterName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}
