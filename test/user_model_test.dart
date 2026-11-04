import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/features/auth/data/user_model.dart';

void main() {
  UserModel make({
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
      expect(make(role: 'student').isStudent, isTrue);
      expect(make(role: 'student').isStaff, isFalse);
      expect(make(role: 'staff').isStaff, isTrue);
      expect(make(role: 'staff').isStudent, isFalse);
    });

    test('firstName extracts first word', () {
      expect(make().firstName, 'Jane');
    });

    test('initials uses first and last name', () {
      expect(make().initials, 'JD');
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
      final user = make(department: 'Engineering');
      expect(user.displayName, 'Jane Doe · Engineering');
    });

    test('displayName is just fullName when no department', () {
      expect(make().displayName, 'Jane Doe');
    });

    test('displayName skips empty department', () {
      expect(make(department: '').displayName, 'Jane Doe');
    });

    test('toJson returns same as toMap', () {
      final user = make();
      expect(user.toJson(), equals(user.toMap()));
    });

    test('toString includes uid, email, role', () {
      final str = make().toString();
      expect(str, contains('uid-1'));
      expect(str, contains('j.doe@alustudent.com'));
      expect(str, contains('student'));
    });

    test('copyWith updates only specified fields', () {
      final user = make(department: 'CS');
      final updated = user.copyWith(fullName: 'Jane Smith');
      expect(updated.fullName, 'Jane Smith');
      expect(updated.department, 'CS');
      expect(updated.email, user.email);
    });
  });
}
