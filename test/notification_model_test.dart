import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/notifications/data/notification_model.dart';

void main() {
  NotificationModel _make({
    bool isRead = false,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: 'notif-1',
      userId: 'user-1',
      incidentId: 'inc-1',
      title: 'Status updated',
      body: 'Your report is now In Progress.',
      isRead: isRead,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  group('NotificationModel', () {
    test('isRecent true for notification created within 24 hours', () {
      final recent = _make(
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      );
      expect(recent.isRecent, isTrue);
    });

    test('isRecent false for notification older than 24 hours', () {
      final old = _make(
        createdAt: DateTime.now().subtract(const Duration(hours: 48)),
      );
      expect(old.isRecent, isFalse);
    });

    test('toJson returns same map as toMap', () {
      final notif = _make();
      expect(notif.toJson(), equals(notif.toMap()));
    });

    test('toString includes id, title, isRead', () {
      final str = _make(isRead: true).toString();
      expect(str, contains('notif-1'));
      expect(str, contains('Status updated'));
      expect(str, contains('true'));
    });

    test('toMap contains all fields', () {
      final map = _make(isRead: false).toMap();
      expect(map['userId'], 'user-1');
      expect(map['incidentId'], 'inc-1');
      expect(map['title'], 'Status updated');
      expect(map['isRead'], false);
    });
  });
}
