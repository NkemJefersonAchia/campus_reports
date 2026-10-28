import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/string_extensions.dart';

void main() {
  group('StringCasing', () {
    test('capitalize works correctly', () {
      expect('hello'.capitalize, 'Hello');
      expect(''.capitalize, '');
      expect('A'.capitalize, 'A');
    });

    test('initials extracts first letters', () {
      expect('John Doe'.initials, 'JD');
      expect('Alice'.initials, 'A');
      expect('  Bob  Smith  '.initials, 'BS');
    });

    test('truncate shortens long strings', () {
      expect('Hello World'.truncate(5), 'Hello...');
      expect('Hi'.truncate(5), 'Hi');
    });
  });
}
