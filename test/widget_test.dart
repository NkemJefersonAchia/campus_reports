import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/validators.dart';
import 'package:campus_reports/core/utils/time_helpers.dart';

void main() {
  group('Validators', () {
    test('email rejects non-ALU domains', () {
      expect(Validators.email('test@gmail.com'), isNotNull);
      expect(Validators.email('test@alustudent.com'), isNull);
      expect(Validators.email('test@alueducation.com'), isNull);
    });

    test('email rejects empty and invalid', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('notanemail'), isNotNull);
    });

    test('password rejects short passwords', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('abc'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('confirmPassword checks match', () {
      expect(Validators.confirmPassword('pass1234', 'pass1234'), isNull);
      expect(Validators.confirmPassword('pass1234', 'different'), isNotNull);
    });

    test('fullName rejects empty', () {
      expect(Validators.fullName(''), isNotNull);
      expect(Validators.fullName('A'), isNotNull);
      expect(Validators.fullName('John Doe'), isNull);
    });

    test('incidentTitle validates length', () {
      expect(Validators.incidentTitle(''), isNotNull);
      expect(Validators.incidentTitle('Hi'), isNotNull);
      expect(Validators.incidentTitle('Valid title here'), isNull);
    });

    test('incidentDescription validates length', () {
      expect(Validators.incidentDescription(''), isNotNull);
      expect(Validators.incidentDescription('Too short'), isNotNull);
      expect(Validators.incidentDescription('This is a valid description that is long enough to pass validation'), isNull);
    });
  });

  group('TimeHelpers', () {
    test('greeting varies by time of day', () {
      final greeting = TimeHelpers.greeting('John');
      expect(greeting, contains('John'));
      expect(greeting, anyOf(contains('morning'), contains('afternoon'), contains('evening')));
    });

    test('relativeTime formats correctly', () {
      final now = DateTime.now();
      expect(TimeHelpers.relativeTime(now), 'Just now');
      expect(TimeHelpers.relativeTime(now.subtract(const Duration(minutes: 5))), '5m ago');
      expect(TimeHelpers.relativeTime(now.subtract(const Duration(hours: 3))), '3h ago');
      expect(TimeHelpers.relativeTime(now.subtract(const Duration(days: 2))), '2d ago');
    });
  });
}
