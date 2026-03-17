import 'package:flutter_test/flutter_test.dart';

import 'package:btlmobile/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateRequired', () {
      test('returns error for null value', () {
        expect(Validators.validateRequired(null), isNotNull);
      });

      test('returns error for empty string', () {
        expect(Validators.validateRequired(''), isNotNull);
      });

      test('returns error for whitespace only', () {
        expect(Validators.validateRequired('   '), isNotNull);
      });

      test('returns null for valid value', () {
        expect(Validators.validateRequired('valid value'), isNull);
      });

      test('uses custom field name in error message', () {
        final result = Validators.validateRequired(null, fieldName: 'Name');
        expect(result, contains('Name'));
      });
    });

    group('validateEmail', () {
      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
      });

      test('returns error for invalid email without @', () {
        expect(Validators.validateEmail('invalidemail'), isNotNull);
      });

      test('returns error for invalid email without domain', () {
        expect(Validators.validateEmail('test@'), isNotNull);
      });

      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
      });

      test('returns null for email with subdomain', () {
        expect(Validators.validateEmail('user@mail.example.com'), isNull);
      });
    });

    group('validatePhone', () {
      test('returns error for empty phone', () {
        expect(Validators.validatePhone(''), isNotNull);
      });

      test('returns error for phone with letters', () {
        expect(Validators.validatePhone('123-abc-4567'), isNotNull);
      });

      test('returns null for valid phone with digits only', () {
        expect(Validators.validatePhone('1234567890'), isNull);
      });

      test('returns null for phone with spaces and dashes', () {
        expect(Validators.validatePhone('123-456-7890'), isNull);
      });

      test('returns null for phone with plus and parentheses', () {
        expect(Validators.validatePhone('+1 (234) 567-8900'), isNull);
      });
    });

    group('validateRating', () {
      test('returns error for empty rating', () {
        expect(Validators.validateRating(''), isNotNull);
      });

      test('returns error for non-numeric rating', () {
        expect(Validators.validateRating('abc'), isNotNull);
      });

      test('returns error for rating below 0', () {
        expect(Validators.validateRating('-1'), isNotNull);
      });

      test('returns error for rating above 5', () {
        expect(Validators.validateRating('6'), isNotNull);
      });

      test('returns null for valid rating 0', () {
        expect(Validators.validateRating('0'), isNull);
      });

      test('returns null for valid rating 5', () {
        expect(Validators.validateRating('5'), isNull);
      });

      test('returns null for valid decimal rating', () {
        expect(Validators.validateRating('4.5'), isNull);
      });
    });

    group('validateMinLength', () {
      test('returns error for value shorter than min', () {
        expect(Validators.validateMinLength('ab', 3), isNotNull);
      });

      test('returns null for value equal to min', () {
        expect(Validators.validateMinLength('abc', 3), isNull);
      });

      test('returns null for value longer than min', () {
        expect(Validators.validateMinLength('abcd', 3), isNull);
      });
    });

    group('validateMaxLength', () {
      test('returns error for value longer than max', () {
        expect(Validators.validateMaxLength('abcdef', 5), isNotNull);
      });

      test('returns null for value equal to max', () {
        expect(Validators.validateMaxLength('abcde', 5), isNull);
      });

      test('returns null for value shorter than max', () {
        expect(Validators.validateMaxLength('abc', 5), isNull);
      });
    });
  });
}
