import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'incident_model.dart';
import 'status_history_model.dart';

class IncidentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  static const _uuid = Uuid();

  IncidentRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get _incidents => _firestore.collection('incidents');

  Stream<List<IncidentModel>> allIncidentsStream() {
    return _incidents
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(IncidentModel.fromFirestore).toList());
  }

  Stream<List<IncidentModel>> userIncidentsStream(String userId) {
    return _incidents
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(IncidentModel.fromFirestore).toList());
  }

  Stream<IncidentModel?> incidentStream(String incidentId) {
    return _incidents.doc(incidentId).snapshots().map(
      (doc) => doc.exists ? IncidentModel.fromFirestore(doc) : null,
    );
  }

  Stream<List<StatusHistoryEntry>> statusHistoryStream(String incidentId) {
    return _incidents
        .doc(incidentId)
        .collection('statusHistory')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(StatusHistoryEntry.fromFirestore).toList());
  }

  Future<String?> uploadPhoto(String userId, File file) async {
    final ext = file.path.split('.').last;
    final ref = _storage.ref('incidents/$userId/${_uuid.v4()}.$ext');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<String> createIncident(IncidentModel incident) async {
    final docRef = _incidents.doc();
    final now = DateTime.now();
    final data = incident.toMap();
    data['createdAt'] = Timestamp.fromDate(now);
    data['updatedAt'] = Timestamp.fromDate(now);
    await docRef.set(data);

    await docRef.collection('statusHistory').add(
      StatusHistoryEntry(
        id: '',
        status: 'Submitted',
        changedBy: incident.reporterId,
        changedByName: incident.reporterName,
        timestamp: now,
      ).toMap(),
    );

    return docRef.id;
  }

  Future<void> updateIncidentStatus({
    required String incidentId,
    required String newStatus,
    required String staffId,
    required String staffName,
    String? note,
    required String reporterId,
    required String incidentTitle,
  }) async {
    final now = DateTime.now();
    final batch = _firestore.batch();

    final docRef = _incidents.doc(incidentId);
    final updates = <String, dynamic>{
      'status': newStatus,
      'updatedAt': Timestamp.fromDate(now),
    };
    if (newStatus == 'Resolved') {
      updates['resolvedAt'] = Timestamp.fromDate(now);
    }
    batch.update(docRef, updates);

    final historyRef = docRef.collection('statusHistory').doc();
    batch.set(historyRef, StatusHistoryEntry(
      id: '',
      status: newStatus,
      note: note,
      changedBy: staffId,
      changedByName: staffName,
      timestamp: now,
    ).toMap());

    final notifRef = _firestore.collection('notifications').doc();
    batch.set(notifRef, {
      'userId': reporterId,
      'incidentId': incidentId,
      'title': 'Status updated',
      'body': 'Your report "$incidentTitle" is now $newStatus.',
      'isRead': false,
      'createdAt': Timestamp.fromDate(now),
    });

    await batch.commit();
  }

  Future<void> deleteIncident(String incidentId) async {
    await _incidents.doc(incidentId).delete();
  }
}
