class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  static final RegExp _phoneRegex = RegExp(r'^0[0-9]{9}$');

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Email phải có dạng example@gmail.com';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 10) {
      return 'Số điện thoại phải đủ 10 số';
    }
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  static String? validateRating(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Rating is required';
    }
    final rating = int.tryParse(value.trim());
    if (rating == null) {
      return 'Vui lòng nhập số nguyên';
    }
    if (rating < 0 || rating > 5) {
      return 'Đánh giá phải từ 0 đến 5 sao';
    }
    return null;
  }

  static String? validateMinLength(
    String? value,
    int minLength, {
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    if (value.trim().length < minLength) {
      return fieldName != null
          ? '$fieldName must be at least $minLength characters'
          : 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String? fieldName,
  }) {
    if (value != null && value.trim().length > maxLength) {
      return fieldName != null
          ? '$fieldName must not exceed $maxLength characters'
          : 'Must not exceed $maxLength characters';
    }
    return null;
  }

  static String? validateNumericRange(
    String? value, {
    double? min,
    double? max,
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (min != null && number < min) {
      return fieldName != null
          ? '$fieldName must be at least $min'
          : 'Must be at least $min';
    }
    if (max != null && number > max) {
      return fieldName != null
          ? '$fieldName must not exceed $max'
          : 'Must not exceed $max';
    }
    return null;
  }

  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');
  static final RegExp _scriptRegex = RegExp(
    r'(javascript:|on\w+=)',
    caseSensitive: false,
  );

  static String sanitize(String input) {
    return input
        .replaceAll(_htmlTagRegex, '')
        .replaceAll(_scriptRegex, '')
        .trim();
  }

  static String? validateAndSanitize(
    String? value, {
    String? fieldName,
    int? maxLength,
  }) {
    final requiredError = validateRequired(value, fieldName: fieldName);
    if (requiredError != null) return requiredError;

    final sanitized = sanitize(value!);
    if (sanitized.isEmpty) {
      return fieldName != null
          ? '$fieldName contains invalid content'
          : 'Invalid content detected';
    }

    if (maxLength != null && sanitized.length > maxLength) {
      return fieldName != null
          ? '$fieldName must not exceed $maxLength characters'
          : 'Must not exceed $maxLength characters';
    }

    return null;
  }
}
