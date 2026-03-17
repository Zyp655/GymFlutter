import 'package:flutter_test/flutter_test.dart';

import 'package:btlmobile/core/utils/validators.dart';

void main() {
  group('Validators.sanitize', () {
    test('removes HTML tags', () {
      expect(
        Validators.sanitize('<script>alert("xss")</script>Hello'),
        'alert("xss")Hello',
      );
    });

    test('removes nested HTML tags', () {
      expect(Validators.sanitize('<b><i>Bold Italic</i></b>'), 'Bold Italic');
    });

    test('removes javascript: protocol', () {
      expect(Validators.sanitize('javascript:alert(1)'), 'alert(1)');
    });

    test('removes inline event handlers', () {
      expect(Validators.sanitize('onclick=stealData()'), 'stealData()');
    });

    test('preserves clean text', () {
      expect(
        Validators.sanitize('Hello World! This is a gym.'),
        'Hello World! This is a gym.',
      );
    });

    test('trims whitespace', () {
      expect(Validators.sanitize('  Hello  '), 'Hello');
    });
  });

  group('Validators.validateAndSanitize', () {
    test('returns error for null input', () {
      expect(
        Validators.validateAndSanitize(null, fieldName: 'Name'),
        'Name is required',
      );
    });

    test('returns error for empty input', () {
      expect(
        Validators.validateAndSanitize('', fieldName: 'Name'),
        'Name is required',
      );
    });

    test('returns error for HTML-only input', () {
      expect(
        Validators.validateAndSanitize('<script></script>', fieldName: 'Name'),
        'Name contains invalid content',
      );
    });

    test('returns error when exceeds maxLength', () {
      expect(
        Validators.validateAndSanitize(
          'A very long string that exceeds the limit',
          fieldName: 'Name',
          maxLength: 10,
        ),
        'Name must not exceed 10 characters',
      );
    });

    test('returns null for valid input', () {
      expect(
        Validators.validateAndSanitize('Valid Gym Name', fieldName: 'Name'),
        null,
      );
    });

    test('returns null for valid input within maxLength', () {
      expect(
        Validators.validateAndSanitize(
          'Short',
          fieldName: 'Name',
          maxLength: 100,
        ),
        null,
      );
    });
  });
}
