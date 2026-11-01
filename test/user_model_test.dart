import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/auth/data/user_model.dart';

void main() {
  UserModel _make({
    String role = 'student',
    String? department,
  }) {
    return UserModel(
      uid: 'uid-1',
      fullName: 'Jane Doe',
      email: 'j.doe@alustudent.com',
      role: role,
      department: department,
      createdAt: DateTime(2026, 10, 1),
    );
  }

  group('UserModel', () {
    test('isStaff and isStudent reflect role', () {
      expect(_make(role: 'student').isStudent, isTrue);
      expect(_make(role: 'student').isStaff, isFalse);
      expect(_make(role: 'staff').isStaff, isTrue);
      expect(_make(role: 'staff').isStudent, isFalse);
    });

    test('firstName extracts first word', () {
      expect(_make().firstName, 'Jane');
    });

    test('initials uses first and last name', () {
      expect(_make().initials, 'JD');
    });

    test('initials handles single name', () {
      final user = UserModel(
        uid: 'u1',
        fullName: 'Jane',
        email: 'jane@alustudent.com',
        role: 'student',
        createdAt: DateTime(2026, 10, 1),
      );
      expect(user.initials, 'J');
    });

    test('displayName includes department when present', () {
      final user = _make(department: 'Engineering');
      expect(user.displayName, 'Jane Doe · Engineering');
    });

    test('displayName is just fullName when no department', () {
      expect(_make().displayName, 'Jane Doe');
    });

    test('displayName skips empty department', () {
      expect(_make(department: '').displayName, 'Jane Doe');
    });

    test('toJson returns same as toMap', () {
      final user = _make();
      expect(user.toJson(), equals(user.toMap()));
    });

    test('toString includes uid, email, role', () {
      final str = _make().toString();
      expect(str, contains('uid-1'));
      expect(str, contains('j.doe@alustudent.com'));
      expect(str, contains('student'));
    });

    test('copyWith updates only specified fields', () {
      final user = _make(department: 'CS');
      final updated = user.copyWith(fullName: 'Jane Smith');
      expect(updated.fullName, 'Jane Smith');
      expect(updated.department, 'CS');
      expect(updated.email, user.email);
    });
  });
}
