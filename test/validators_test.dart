import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/validators.dart';

void main() {
  group('email', () {
    test('rejects empty email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });
    test('rejects invalid format', () {
      expect(Validators.email('notanemail'), isNotNull);
    });
    test('rejects non-ALU domain', () {
      expect(Validators.email('user@gmail.com'), isNotNull);
    });
    test('accepts ALU student email', () {
      expect(Validators.email('j.nkem@alustudent.com'), isNull);
    });
    test('accepts ALU education email', () {
      expect(Validators.email('admin@alueducation.com'), isNull);
    });
  });

  group('password', () {
    test('rejects empty', () {
      expect(Validators.password(''), isNotNull);
    });
    test('rejects short password', () {
      expect(Validators.password('Ab1'), isNotNull);
    });
    test('requires uppercase letter', () {
      expect(Validators.password('abcdefg1'), isNotNull);
    });
    test('requires digit', () {
      expect(Validators.password('Abcdefgh'), isNotNull);
    });
    test('accepts valid password', () {
      expect(Validators.password('Secure123'), isNull);
    });
  });

  group('fullName', () {
    test('rejects empty', () {
      expect(Validators.fullName(''), isNotNull);
    });
    test('rejects too short', () {
      expect(Validators.fullName('A'), isNotNull);
    });
    test('rejects too long', () {
      expect(Validators.fullName('A' * 51), isNotNull);
    });
    test('accepts valid name', () {
      expect(Validators.fullName('Nkem Achia'), isNull);
    });
  });

  group('incidentTitle', () {
    test('rejects empty', () {
      expect(Validators.incidentTitle(''), isNotNull);
    });
    test('rejects too short', () {
      expect(Validators.incidentTitle('Hi'), isNotNull);
    });
    test('accepts valid title', () {
      expect(Validators.incidentTitle('Broken pipe in Block A'), isNull);
    });
  });
}
