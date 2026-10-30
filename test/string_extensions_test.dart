import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/utils/string_extensions.dart';

void main() {
  group('capitalize', () {
    test('capitalizes first letter', () {
      expect('hello'.capitalize, 'Hello');
    });
    test('handles empty string', () {
      expect(''.capitalize, '');
    });
  });

  group('initials', () {
    test('returns two letters for full name', () {
      expect('John Doe'.initials, 'JD');
    });
    test('returns one letter for single name', () {
      expect('John'.initials, 'J');
    });
    test('returns ? for empty string', () {
      expect(''.initials, '?');
    });
  });

  group('truncate', () {
    test('returns full string when under limit', () {
      expect('hello'.truncate(10), 'hello');
    });
    test('truncates with ellipsis', () {
      expect('hello world'.truncate(5), 'hello...');
    });
  });

  group('wordCount', () {
    test('counts words correctly', () {
      expect('hello world'.wordCount, 2);
      expect('one'.wordCount, 1);
      expect(''.wordCount, 0);
      expect('  spaced   out  words  '.wordCount, 3);
    });
  });

  group('isValidUrl', () {
    test('validates URLs', () {
      expect('https://example.com/path'.isValidUrl, isTrue);
      expect('not a url'.isValidUrl, isFalse);
    });
  });
}
