import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String incidentId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.incidentId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  bool get isRecent =>
      DateTime.now().difference(createdAt).inHours < 24;

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() =>
      'NotificationModel(id: $id, title: $title, isRead: $isRead)';

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      incidentId: data['incidentId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'incidentId': incidentId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
